//
//  UserRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import Foundation

protocol UserRepository {
    func createUser(user: AoiUser) async throws
    func getUser(uid: String) async throws -> AoiUser? 
}

