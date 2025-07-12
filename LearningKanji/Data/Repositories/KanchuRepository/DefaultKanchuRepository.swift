
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
}


// MARK: - Main Repository Implementation
final class DefaultKanchuRepository: KanchuRepository {
    
    enum GeminiError: Error, LocalizedError {
        case apiKeyNotFound
        case invalidURL
        case requestEncodingFailed(Error)
        case responseDecodingFailed(Error)
        case noContentReceived
        case jsonParsingFailed
        case apiError(String)
        case kanjiFetchingFailed(Error)

        var errorDescription: String? {
            switch self {
            case .apiKeyNotFound: return "API 키를 찾을 수 없습니다. GenerativeAI-Info.plist를 확인하세요."
            case .invalidURL: return "잘못된 API URL입니다."
            case .requestEncodingFailed: return "요청 데이터를 인코딩하는 데 실패했습니다."
            case .responseDecodingFailed: return "응답 데이터를 디코딩하는 데 실패했습니다."
            case .noContentReceived: return "API로부터 콘텐츠를 받지 못했습니다."
            case .jsonParsingFailed: return "수신된 JSON을 파싱하는 데 실패했습니다."
            case .apiError(let message): return "API 에러: \(message)"
            case .kanjiFetchingFailed: return "퀴즈를 만들 한자를 가져오는 데 실패했습니다."
            }
        }
    }
    
    private let apiKey: String
    private let session: URLSession
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(session: URLSession = .shared, commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository) throws {
        guard let path = Bundle.main.path(forResource: "ApiKeyList", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["GEMINI_API_KEY"] as? String, !key.isEmpty else {
            throw GeminiError.apiKeyNotFound
        }
        self.apiKey = key
        self.session = session
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
    }
    
    func fetchProblems(kanjiList: [Kanji], problemType: ProblemType, count: Int) async throws -> [KanchuProblem] {
        
        // 2. Gemini API 요청 생성
        let request = try buildRequest(kanjiList: kanjiList.map { $0.kanji }, problemType: problemType, count: count)
        
        // 3. API 호출 및 응답 처리
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorText = String(data: data, encoding: .utf8) ?? "알 수 없는 에러"
            throw GeminiError.apiError("Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0), \(errorText)")
        }
        
        // 5. JSON을 퀴즈 문제 배열로 디코딩
        let geminiProblems: [GeminiKanchuProblem]
        do {
            geminiProblems = try JSONDecoder().decode([GeminiKanchuProblem].self, from: data)
        } catch {
            throw GeminiError.responseDecodingFailed(error)
        }
        
        // 6. Domain 모델로 매핑
        let problems = geminiProblems.map {
            KanchuProblem(id: UUID(), type: problemType, sentence: $0.sentence, targetWord: $0.targetWord, options: $0.options, answer: $0.answer)
        }
        
        return problems
    }
    
    private func buildRequest(kanjiList: [String], problemType: ProblemType, count: Int) throws -> URLRequest {
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$GOOGLE_API_KEY"
        guard let url = URL(string: urlString) else {
            throw GeminiError.invalidURL
        }
        
        let prompt = createPrompt(kanjiList: kanjiList, problemType: problemType, count: count)
        let schema = createSchema()
        
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
    
    private func createPrompt(kanjiList: [String], problemType: ProblemType, count: Int) -> String {
        let kanjiString = kanjiList.joined(separator: ", ")
        
        // 사용자가 제공한 프롬프트 템플릿을 기반으로 구성
        return """
        당신은 일본어 상용한자 읽기 능력 평가를 위한 퀴즈를 만드는 전문 교사입니다.

        아래 '퀴즈 조건'에 따라, 주어진 '대상 한자' 목록의 한자들만으로 핵심 단어를 만들어, 문맥에 맞는 읽기(読み方)를 맞추는 객관식 퀴즈 \(count)개를 생성해 주세요.

        [대상 한자]
        [\(kanjiString)]

        [퀴즈 조건]
        1. 핵심 단어 생성:
        반드시 '대상 한자' 목록에 있는 한자 1개 또는 2개 이상을 조합하여 의미가 통하는 일본어 상용 단어 1개를 만듭니다. (예: [医, 院]이 목록에 있다면 医院 생성 가능. 安만 있다면 安全은 생성 불가)
        이 때 단일 한자로 된 단어도 적극 활용합니다. (예: 愛, 悪)
        한자를 조합하여 명사, 동사, 형용사 등의 다양한 종류의 단어 중 하나를 만듭니다.
        동사나 형용사를 만들 경우, 한자 뒤에 붙는 히라가나(오쿠리가나)까지 포함하여 하나의 완전한 단어로 만듭니다. (예: [食]이 목록에 있다면 食べる 생성, [新]이 있다면 新しい 생성)
        2. 문장 생성:
        생성한 핵심 단어를 사용하여 자연스러운 일본어 예문을 만듭니다.
        핵심 단어를 제외한 문장의 다른 부분에는 '대상 한자' 목록에 없는 한자가 절대로 포함되어서는 안됩니다.
        3. 문제 형식:
        예문 속 핵심 단어를 괄호로 묶습니다.
        해당 단어의 올바른 읽기(정답)를 히라가나로 제시합니다.
        정답과 함께, 학습자가 헷갈릴 만한 오답(히라가나) 3개를 추가하여 총 4개의 보기를 만듭니다.
        4개의 보기는 무작위 순서로 배열합니다.
        """
    }
    
    private func createSchema() -> GeminiAPIRequest.JSONSchema {
        let problemSchema = GeminiAPIRequest.JSONSchema(
            type: "object",
            description: "한자 읽기 퀴즈 문제 하나를 나타내는 구조입니다.",
            properties: [
                "targetWord": .init(type: "string", description: "퀴즈의 대상이 되는 핵심 단어(한자)입니다."),
                "sentence": .init(type: "string", description: "핵심 단어가 괄호로 묶여 포함된 예문입니다."),
                "options": .init(type: "array", description: "정답 1개와 오답 3개로 구성된 총 4개의 히라가나 보기 목록입니다.", items: .init(type: "string")),
                "answer": .init(type: "string", description: "4개의 보기 중 정답에 해당하는 히라가나입니다.")
            ],
            required: ["targetWord", "sentence", "options", "answer"]
        )
        
        // 문제 객체의 배열을 최상위 구조로 정의
        return GeminiAPIRequest.JSONSchema(
            type: "array",
            description: "생성된 한자 퀴즈 문제의 목록입니다.",
            items: problemSchema
        )
    }
}
