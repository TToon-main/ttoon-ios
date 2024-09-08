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
    case postIsValidNickName(dto: PostIsValidNickNameRequestDTO)
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
        case .postIsValidNickName:
            return "/api/join"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .socialLogin, .postRefreshToken, .postIsValidNickName:
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
            
        case .postIsValidNickName(let dto):
            return .requestJSONEncodable(dto)
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

        case .postIsValidNickName:
            return nil
        }
    }
}
