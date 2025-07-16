//
//  DefaultKanchuRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/12/25.
//

import Foundation

// MARK: - Gemini API Request/Response Models
private struct GeminiAPIRequest: Encodable {
    let contents: [Content]
    let generationConfig: GenerationConfig

    struct Content: Encodable {
        let parts: [Part]
    }

    struct Part: Encodable {
        let text: String
    }
    
    struct GenerationConfig: Encodable {
        let responseMimeType: String
        let responseSchema: JSONSchema
        
        enum CodingKeys: String, CodingKey {
            case responseMimeType = "response_mime_type"
            case responseSchema = "response_schema"
        }
    }

    class JSONSchema: Encodable {
        let type: String
        let description: String?
        let properties: [String: JSONSchema]?
        let items: JSONSchema?
        let required: [String]?
        
        init(type: String, description: String? = nil, properties: [String : JSONSchema]? = nil, items: JSONSchema? = nil, required: [String]? = nil) {
            self.type = type
            self.description = description
            self.properties = properties
            self.items = items
            self.required = required
        }
    }
}

private struct GeminiAPIResponse: Decodable {
    let candidates: [Candidate]
    
    struct Candidate: Decodable {
        let content: Content
    }

    struct Content: Decodable {
        let parts: [Part]
    }

    struct Part: Decodable {
        let text: String
    }
}

/// Gemini API가 생성할 퀴즈 문제의 JSON 구조에 매핑되는 모델
private struct GeminiKanchuProblem: Decodable {
    let targetWord: String
    let sentence: String
    let options: [String]
    let answer: String
    let targetKanji: String
}


// MARK: - Main Repository Implementation
final class DefaultKanchuRepository: KanchuRepository {
    
    enum GeminiError: Error, LocalizedError {
        case apiKeyNotFound
        case invalidURL
        case requestEncodingFailed(Error)
        case responseDecodingFailed(Error)
        case apiError(String)
        case kanjiFetchingFailed(Error)
        case kanjiListEmpty

        var errorDescription: String? {
            switch self {
            case .apiKeyNotFound: return "API 키를 찾을 수 없습니다. GenerativeAI-Info.plist를 확인하세요."
            case .invalidURL: return "잘못된 API URL입니다."
            case .requestEncodingFailed: return "요청 데이터를 인코딩하는 데 실패했습니다."
            case .responseDecodingFailed: return "응답 데이터를 디코딩하는 데 실패했습니다."
            case .apiError(let message): return "API 에러: \(message)"
            case .kanjiFetchingFailed: return "퀴즈를 만들 한자를 가져오는 데 실패했습니다."
            case .kanjiListEmpty: return "kanjiList가 비어있습니다."
            }
        }
    }
    
    enum KanchuRepositoryError: Error, LocalizedError {
        case kanjiListLessThanCount
        
        var errorDescription: String? {
            switch self {
            case .kanjiListLessThanCount: return "kanjiList의 길이가 퀴즈 문제로 필요한 수보다 적습니다."
            }
        }
    }
    
    private let apiKey: String
    private let session: URLSession
    
    init(session: URLSession = .shared) throws {
        guard let path = Bundle.main.path(forResource: "ApiKeyList", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["GEMINI_API_KEY"] as? String, !key.isEmpty else {
            throw GeminiError.apiKeyNotFound
        }
        self.apiKey = key
        self.session = session
    }
    
    func fetchProblems(kanjiList: [Kanji], problemType: ProblemType, count: Int) async throws -> [KanchuProblem] {
        if kanjiList.count < count {
            throw KanchuRepositoryError.kanjiListLessThanCount
        }
        
        let request = try buildRequest(kanjiList: kanjiList.map { $0.kanji }, problemType: problemType, count: count)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorText = String(data: data, encoding: .utf8) ?? "알 수 없는 에러"
            throw GeminiError.apiError("Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0), \(errorText)")
        }
        
        let geminiProblems: [GeminiKanchuProblem]
        do {
            // 1. 전체 응답을 GeminiAPIResponse로 디코딩
            let apiResponse = try JSONDecoder().decode(GeminiAPIResponse.self, from: data)
            
            // 2. text 부분(JSON 문자열)을 추출하여 [GeminiKanchuProblem]으로 디코딩
            guard let jsonText = apiResponse.candidates.first?.content.parts.first?.text,
                  let jsonData = jsonText.data(using: .utf8) else {
                throw GeminiError.responseDecodingFailed(CocoaError(.fileReadCorruptFile))
            }
            geminiProblems = try JSONDecoder().decode([GeminiKanchuProblem].self, from: jsonData)
            
        } catch let error as DecodingError {
            // 디코딩 에러를 더 자세히 출력하기 위해 추가
            print("Decoding Error: \(error)")
            throw GeminiError.responseDecodingFailed(error)
        } catch {
            throw GeminiError.responseDecodingFailed(error)
        }
        
        let problems = geminiProblems.map {
            KanchuProblem(id: UUID(), type: problemType, sentence: $0.sentence, targetKanji: $0.targetKanji, options: $0.options, answer: $0.answer, targetWord: $0.targetWord)
        }
        
        return problems
    }
    
    private func buildRequest(kanjiList: [String], problemType: ProblemType, count: Int) throws -> URLRequest {
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw GeminiError.invalidURL
        }
        
        let prompt: String
        let schema: GeminiAPIRequest.JSONSchema
        switch problemType {
        case .findReading:
            prompt = try createFindReadingPrompt(kanjiList: kanjiList, count: count)
            schema = createFindReadingSchema()
        case .findKanji:
            prompt = try createFindReadingPrompt(kanjiList: kanjiList, count: count)
            schema = createFindReadingSchema()
        case .fillReading:
            prompt = try createFillReadingPrompt(kanjiList: kanjiList, count: count)
            schema = createFillReadingSchema()
        }
        
        let requestBody = GeminiAPIRequest(
            contents: [.init(parts: [.init(text: prompt)])],
            generationConfig: .init(responseMimeType: "application/json", responseSchema: schema)
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            throw GeminiError.requestEncodingFailed(error)
        }
        
        return request
    }
    
    private func createFindReadingPrompt(kanjiList: [String], count: Int) throws -> String {
        let kanjiString = Array(kanjiList.shuffled().prefix(count))
        
        // 사용자가 제공한 프롬프트 템플릿을 기반으로 구성
        return """
        [역할]
        당신은 일본어 교육 및 평가 콘텐츠 제작 전문가입니다. 특히, 학습자의 수준에 맞는 어휘와 문법적으로 정확한 예문을 구성하는 데 능숙합니다.

        [지시사항]
        아래 **[입력 정보]**에 명시된 [한자 리스트]를 사용하여, 다음 과정을 통해 객관식 퀴즈를 생성해야 합니다. 리스트에 있는 각 한자당 하나의 문제를 순서대로 만들어야 합니다.

        각 한자에 대한 문제 생성은 아래 2단계로 이루어집니다.

        1단계: 단어 선정
        주어진 한자를 포함하는 일본어 단어를 하나 선정합니다. 이때, 단어의 난이도는 주어진 한자의 일반적인 사용 수준(예: JLPT 급수)과 비슷해야 합니다.

        2단계: 문제 생성
        1단계에서 선정한 단어를 사용하여, 이어지는 **[규칙]**과 **[JSON 스키마]**에 따라 문장형 객관식 문제를 생성합니다.

        [한자 리스트]
        \(kanjiString)

        [규칙]

        target_word와 예문의 형태 일치: target_word 필드에는 반드시 사전형이 아닌, sentence에 실제 사용된 활용형 단어를 그대로 기입해야 합니다. (예: 예문이 友達に会います이면, target_word는 会う가 아닌 会います가 되어야 합니다.)

        선택지와 정답 기준: 선택지(options)와 정답(answer)은 위 1번 규칙에 따라 target_word로 지정된 활용형 단어의 실제 발음을 기준으로 만들어야 합니다. (예: target_word가 会います이면 정답은 あいます입니다.)

        난이도 일치: 생성되는 **예문(sentence)**의 전체적인 어휘 수준과 문법 구조는, 문제의 기반이 되는 [한자]의 난이도와 비슷해야 합니다. 예를 들어, 쉬운 한자(N5 수준)에는 간단한 문장을, 어려운 한자(N1 수준)에는 좀 더 복잡한 문장을 사용해야 합니다.

        최종 출력되는 문제의 순서는 [한자 리스트]의 순서와 정확히 일치해야 합니다.

        각 문제 객체 안에는 kanji 프로퍼티를 포함하여, 어떤 한자로 문제를 만들었는지 명시해야 합니다.

        오답 선택지 3개는 매우 중요합니다. 정답과 비슷하게 보이거나, 한자를 잘못 읽기 쉬운 발음, 혹은 흔한 실수(장음/단음, 탁음/반탁음 등)를 유도하는 그럴듯한 오답으로 구성해야 합니다.

        모든 텍스트는 일본어로 작성하며, JSON 형식 규칙을 엄격히 준수합니다.
        """
    }
    
    private func createFillReadingPrompt(kanjiList: [String], count: Int) throws -> String {
        let kanjiString = Array(kanjiList.shuffled().prefix(count))
        
        return """
        [역할]
        당신은 일본어 교육 및 평가 콘텐츠 제작 전문가입니다.

        [지시사항]
        아래 **[한자 리스트]**에 명시된 각 한자에 대해, 이어지는 **[규칙]**과 **[JSON 스키마]**에 맞춰 하나씩의 객관식 퀴즈 문제를 생성하여 전체 퀴즈를 구성해야 합니다.

        [한자 리스트]
        \(kanjiString)

        [규칙]

        1. 위에 명시된 [한자 리스트]의 순서에 맞춰 퀴즈 문제의 순서를 구성합니다. (첫 번째 한자로 첫 번째 문제, 두 번째 한자로 두 번째 문제 생성)

        2. 각 문제 객체 안에는 kanji 프로퍼티를 포함하여, 해당 문제가 어떤 한자를 기반으로 만들어졌는지 명시해야 합니다.

        3. 문제는 주어진 한자가 포함된, 교육적으로 의미 있고 사용 빈도가 높은 일본어 단어를 기반으로 생성합니다.

        4. 단어의 발음 중, 해당 문제의 kanji에 해당하는 부분을 빈칸(___)으로 만들어 문제를 출제합니다.

        5. 정답 선택지 1개와, 그럴듯한 오답 선택지 3개를 구성하여 총 4개의 선택지를 options 배열에 문자열로 담습니다.

        6. 정답에 해당하는 발음은 answer 필드에 별도로 명시합니다.
        
        [예시]
        {
          "target_kanji": "語",
          "quiz": [
            {
              "word": "日本語",
              "question": "にほん___",
              "options": [
                "ご",
                "ごう",
                "か",
                "が"
              ],
              "answer": "ご"
            }
          ]
        }
        """
    }
    
    private func createFillReadingSchema() -> GeminiAPIRequest.JSONSchema {
        let problemSchema = GeminiAPIRequest.JSONSchema(
            type: "object",
            description: "빈칸 읽기 퀴즈 문제 객체. 각 문제는 한자, 빈칸이 포함된 문장, 4개의 선택지, 정답을 가집니다.",
            properties: [
                "targetKanji": .init(type: "string", description: "이 문제의 대상이 된 한자 문자입니다."),
                "targetWord": .init(type: "string", description: "한자가 포함된 전체 단어"),
                "sentence": .init(type: "string", description: "발음의 일부가 빈칸(___)으로 처리된 문제"),
                "options": .init(type: "array", description: "정답 1개와 오답 3개를 포함한 4개의 선택지 발음(히라가나) 목록", items: .init(type: "string")),
                "answer": .init(type: "string", description: "options 중 정답에 해당하는 발음")
            ],
            required: ["targetKanji", "targetWord", "sentence", "options", "answer"]
        )
        
        return GeminiAPIRequest.JSONSchema(
            type: "array",
            description: "생성된 빈칸 읽기 퀴즈 문제의 배열입니다.",
            items: problemSchema
        )
    }
    
    private func createFindReadingSchema() -> GeminiAPIRequest.JSONSchema {
        let problemSchema = GeminiAPIRequest.JSONSchema(
            type: "object",
            description: "한자 퀴즈 문제 하나를 나타내는 구조입니다.",
            properties: [
                "targetKanji": .init(type: "string", description: "한자 리스트에 있던, 이 문제의 기반이 된 한자"),
                "targetWord": .init(type: "string", description: "AI가 생성한, 이 문제의 대상이 되는 핵심 단어"),
                "sentence": .init(type: "string", description: "대상 단어가 포함된 일본어 예문"),
                "options": .init(type: "array", description: "4개의 선택지 발음(히라가나) 목록", items: .init(type: "string")),
                "answer": .init(type: "string", description: "options 중 정답에 해당하는 발음")
            ],
            required: ["targetKanji", "targetWord", "sentence", "options", "answer"]
        )
        
        // 문제 객체의 배열을 최상위 구조로 정의
        return GeminiAPIRequest.JSONSchema(
            type: "array",
            description: "생성된 한자 퀴즈 문제의 목록입니다.",
            items: problemSchema
        )
    }
}
