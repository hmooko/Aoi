//
//  DefaultUserRepositoryTests.swift
//  LearningKanjiTests
//
//  Created by koohyunmo on 8/7/25.
//

import XCTest
@testable import LearningKanji // LearningKanji 모듈에 접근하기 위해 필요합니다.
import FirebaseFirestore // Firestore 접근을 위해 필요합니다.
import FirebaseAuth // 필요하다면 Firebase 인증 관련 로직도 사용할 수 있습니다.

// UserRepository 통합 테스트 클래스
final class UserRepositoryIntegrationTests: XCTestCase {

    var userRepository: DefaultUserRepository!
    private var testUID: String = UUID().uuidString // 각 테스트에 고유한 UID를 사용합니다.

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Firebase Firestore가 올바르게 초기화되었는지 확인합니다.
        // 앱의 Firebase 설정이 테스트 타겟에도 포함되어 있어야 합니다.
        userRepository = DefaultUserRepository()
        testUID = UUID().uuidString // 각 테스트 메소드 실행 전에 고유한 UID 생성
    }

    override func tearDownWithError() throws {
        // 테스트 후 생성된 사용자 데이터를 클린업합니다.
        let db = Firestore.firestore()
        Task {
            do {
                try await db.collection("users").document(testUID).delete()
                print("Cleaned up user with UID: \(testUID)")
            } catch {
                print("Error cleaning up user data for UID \(testUID): \(error.localizedDescription)")
            }
        }
        userRepository = nil
        try super.tearDownWithError()
    }

    // MARK: - Integration Tests

    func testCreateAndGetUser() async throws {
        // AI 사용 가능 횟수가 Int 타입이므로, 정확한 값으로 초기화합니다.
        let newUser = AoiUser(uid: testUID, email: "\(testUID)@example.com", name: "Test User \(testUID)", aiUsageCount: 5)

        // 1. 사용자 생성 테스트
        do {
            try await userRepository.createUser(user: newUser)
            print("User created successfully: \(newUser.uid)")
        } catch {
            XCTFail("Error creating user: \(error.localizedDescription)")
            // 실제 에러 메시지를 출력하여 디버깅에 도움을 줍니다.
            if let firebaseError = error as NSError? {
                print("Firebase Error Code: \(firebaseError.code), Domain: \(firebaseError.domain)")
            }
            throw error // 테스트 실패 후 에러를 상위로 전파합니다.
        }

        // 2. 사용자 조회 테스트
        let fetchedUser = try await userRepository.getUser(uid: newUser.uid)
        guard let fetchedUser = fetchedUser else {
            XCTFail("Fetched user should not be nil")
            return
        }

        XCTAssertEqual(fetchedUser.uid, newUser.uid, "Fetched user UID should match")
        XCTAssertEqual(fetchedUser.email, newUser.email, "Fetched user email should match")
        XCTAssertEqual(fetchedUser.name, newUser.name, "Fetched user name should match")
        XCTAssertEqual(fetchedUser.aiUsageCount, newUser.aiUsageCount, "Fetched user aiUsageCount should match")

        print("User fetched successfully and matches created user.")
    }

    func testGetUserNotFound() async throws {
        let nonExistentUID = "non_existent_uid_\(UUID().uuidString)"
        let fetchedUser = try await userRepository.getUser(uid: nonExistentUID)

        XCTAssertNil(fetchedUser, "Fetching a non-existent user should return nil")
        print("Successfully confirmed that non-existent user returns nil.")
    }

    func testCreateUserTwiceShouldUpdate() async throws {
        let initialUser = AoiUser(uid: testUID, email: "\(testUID)@initial.com", name: "Initial User", aiUsageCount: 10)
        try await userRepository.createUser(user: initialUser)

        // aiUsageCount가 옵셔널이 아니므로 정확한 값을 넣어줍니다.
        let updatedUser = AoiUser(uid: testUID, email: "\(testUID)@updated.com", name: "Updated User", aiUsageCount: 20)
        try await userRepository.createUser(user: updatedUser) // Firestore setData는 upsert 동작

        let fetchedUser = try await userRepository.getUser(uid: testUID)
        guard let fetchedUser = fetchedUser else {
            XCTFail("Fetched user should not be nil after update")
            return
        }

        XCTAssertEqual(fetchedUser.email, updatedUser.email, "User email should be updated")
        XCTAssertEqual(fetchedUser.name, updatedUser.name, "User name should be updated")
        XCTAssertEqual(fetchedUser.aiUsageCount, updatedUser.aiUsageCount, "User aiUsageCount should be updated")
        print("User updated successfully by calling createUser twice.")
    }
    
    func test유저만들어보기() async throws {
        // 개별 doc: false, 전체 doc: true -> 결국 전부 true, 개별 doc: true, 전체 doc: false -> 개별 doc만 true,
        let initialUser = AoiUser(uid: testUID, email: "\(testUID)@test.com", name: "Test User", aiUsageCount: 10)
        try await userRepository.createUser(user: initialUser)
    }
    
    func test유저불러오기() async throws {
        let user = try await userRepository.getUser(uid: "66BA911C-AFB2-48F7-93CB-9386D3E0BCF9")
        print(user)
    }
}
