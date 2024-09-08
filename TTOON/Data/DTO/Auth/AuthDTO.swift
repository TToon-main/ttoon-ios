//
//  AuthDTO.swift
//  TTOON
//
//  Created by 임승섭 on 5/12/24.
//

import Foundation

// 스플래시


// 로그인
struct LoginRequestDTO {
    let providerID: String
    let provider: String
    let email: String
}

struct LoginResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let isGuest: Bool
}

extension LoginResponseDTO {
    func toDomain() -> LoginResponseModel {
        return .init(
            accessToken: accessToken,
            refreshToken: refreshToken,
            isGuest: isGuest
        )
    }
}

struct PostRefreshTokenRequestDTO {
    let accessToken: String
    let refreshToken: String
}

struct PostRefreshTokenResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let isGuest: Bool
}

struct PostIsValidNickNameRequestDTO: Codable {
    let nickName: String
}
