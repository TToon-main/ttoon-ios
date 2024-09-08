//
//  LoginAPI.swift
//  TTOON
//
//  Created by 임승섭 on 5/12/24.
//

import Foundation

import Moya

// 에픽 단위로 만들기 - 나중에 Splash랑 합치기 (Auth API)

enum LoginAPI {
    case postRefreshToken(dto: PostRefreshTokenRequestDTO)
    case socialLogin(dto: LoginRequestDTO)
}

extension LoginAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttoon.site")!
    }
    
    var path: String {
        switch self {
        case .socialLogin:
            return "/api/auth/app/login"
        case .postRefreshToken:
            return "/api/auth/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .socialLogin, .postRefreshToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .socialLogin(let dto):
            let params: [String: String] = [
                "provider": dto.provider,
                "providerId": dto.providerID,
                "email": dto.email
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
            
        case .postRefreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .socialLogin:
            return ["Content-type": "application/json"]
            
        case .postRefreshToken(let dto):
            return ["Content-type": "application/json", 
                    "Authorization": "Bearer \(dto.accessToken)",
                    "refreshToken": "\(dto.refreshToken)"]
        }
    }
}
