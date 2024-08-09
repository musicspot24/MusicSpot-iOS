//
//  RemoteUserRepository.swift
//  RemoteRepository
//
//  Created by 이창준 on 7/1/24.
//

import Foundation

import Entity
import Repository

public final class RemoteUserRepository: UserRepository {

    // MARK: Nested Types

    public enum ActivationMethod {
        case signUp
        case login
    }

    // MARK: Functions

    @discardableResult
    public func activate(newUserID: String) throws -> User {
        // TODO: - 회원가입 / 로그인 구현
        User(id: newUserID)
    }

    public func deactivate(userID _: String) throws {
        // TODO: - 로그아웃 / 회원탈퇴 구현
    }
}
