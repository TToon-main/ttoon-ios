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
    let provider: String
    let providerID: String
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
