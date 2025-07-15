//
//  DefaultKanchuRepositoryTests.swift
//  LearningKanjiTests
//
//  Created by koohyunmo on 7/13/25.
//

import XCTest
@testable import LearningKanji

// MARK: - Mock URLProtocol for Network Mocking
class MockURLProtocol: URLProtocol {
    static var mockData: Data?
    static var mockResponse: URLResponse?
    static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true // Intercept all requests.
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = MockURLProtocol.mockResponse {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = MockURLProtocol.mockData {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required override, but nothing to do.
    }
}

// MARK: - Test Class
class DefaultKanchuRepositoryTests: XCTestCase {

    var sut: DefaultKanchuRepository!
    var session: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        
        // IMPORTANT: This test suite requires that `ApiKeyList.plist` with a valid (or dummy)
        // `GEMINI_API_KEY` is included in the test target's resources.
        // The `DefaultKanchuRepository` initializer will fail if the file or key is not found.
        // This is a known dependency from the current implementation.
        do {
            sut = try DefaultKanchuRepository(session: session)
        } catch {
            XCTFail("Failed to initialize DefaultKanchuRepository. Ensure ApiKeyList.plist is correctly set up for the test target. Error: \(error)")
        }
    }

    override func tearDownWithError() throws {
        sut = nil
        session = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = nil
        MockURLProtocol.mockError = nil
        try super.tearDownWithError()
    }

    // MARK: - Test Cases
    func test_hi() async throws {
        XCTAssertTrue(true, "하이용")
    }

    func test_fetchProblems_succeedsWithValidData() async throws {
        // Given
        let mockProblemsJSON = """
        [
            {
                "targetWord": "試験",
                "sentence": "明日は(試験)があります。",
                "options": ["しけん", "じっけん", "ためし", "こころみ"],
                "answer": "しけん"
            },
            {
                "targetWord": "勉強",
                "sentence": "毎日日本語を(勉強)します。",
                "options": ["べんきょう", "つとむ", "まなぶ", "ならう"],
                "answer": "べんきょう"
            }
        ]
        """
        MockURLProtocol.mockData = mockProblemsJSON.data(using: .utf8)
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let dummyKanji = [
            Kanji(
                id: 1090,
                kanji: "試",
                grade: "초등학교4학년",
                sound: "し",
                meaning: "こころみる、ためす",
                korean: "시험 시"
            ),
            Kanji(
                id: 2017,
                kanji: "験",
                grade: "초등학교4학년",
                sound: "けん、げん",
                meaning: "無し",
                korean: "시험 험"
            )
        ]

        // When
        let problems = try await sut.fetchProblems(kanjiList: dummyKanji, problemType: .findReading, count: 2)

        // Then
        XCTAssertEqual(problems.count, 2)
        XCTAssertEqual(problems[0].targetKanji, "試験")
        XCTAssertEqual(problems[0].answer, "しけん")
        XCTAssertEqual(problems[1].targetKanji, "勉強")
        XCTAssertEqual(problems[1].answer, "べんきょう")
    }

    func test_fetchProblems_failsWithApiError() async {
        // Given
        let errorDetail = "Invalid API key"
        MockURLProtocol.mockData = "{\"error\": {\"message\": \"\(errorDetail)\"}}".data(using: .utf8)
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 400, // Bad Request
            httpVersion: nil,
            headerFields: nil
        )
        
        let dummyKanji = Kanji.sampleKanjiList

        // When & Then
        do {
            _ = try await sut.fetchProblems(kanjiList: dummyKanji, problemType: .findReading, count: 1)
            XCTFail("An error should have been thrown.")
        } catch {
            guard let geminiError = error as? DefaultKanchuRepository.GeminiError else {
                XCTFail("Incorrect error type thrown: \(error)")
                return
            }
            
            if case let .apiError(message) = geminiError {
                // Assert that the error message contains the expected status code and detail.
                XCTAssert(message.contains("Status Code: 400"), "Error message should contain the status code.")
                XCTAssert(message.contains(errorDetail), "Error message should contain the API error detail.")
            } else {
                XCTFail("Expected .apiError, but got \(geminiError)")
            }
        }
    }
    
    func test_fetchProblems_failsWithDecodingError() async {
        // Given
        MockURLProtocol.mockData = "{\"invalid_json\": true}".data(using: .utf8)
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let dummyKanji = Kanji.sampleKanjiList

        // When & Then
        do {
            _ = try await sut.fetchProblems(kanjiList: dummyKanji, problemType: .findReading, count: 1)
            XCTFail("A decoding error should have been thrown.")
        } catch {
            guard let geminiError = error as? DefaultKanchuRepository.GeminiError else {
                XCTFail("Incorrect error type thrown: \(error)")
                return
            }
            
            if case .responseDecodingFailed = geminiError {
                // Test passed, the correct error type was thrown.
            } else {
                XCTFail("Expected .responseDecodingFailed, but got \(geminiError)")
            }
        }
    }

    func test_fetchProblems_failsWithNetworkError() async {
        // Given
        MockURLProtocol.mockError = URLError(.notConnectedToInternet)

        let dummyKanji = Kanji.sampleKanjiList

        // When & Then
        do {
            _ = try await sut.fetchProblems(kanjiList: dummyKanji, problemType: .findReading, count: 1)
            XCTFail("A network error should have been thrown.")
        } catch {
            // The URLSession will throw the original URLError, not a GeminiError.
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
}
