//
//  SettingAPI.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation
import Moya


enum SettingAPI {
    case contactUs(dto: ContactUsRequestDTO)
    case deleteAccount(dto: DeleteAccountRequestDTO)
    case getUserInfo
}

extension SettingAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttoon.site")!
    }
    
    var path: String {
        switch self {
        case .contactUs:
            return "/api/ask"
        case .deleteAccount:
            return "/api/revoke"
        case .getUserInfo:
            return "/api/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .contactUs:
            return .post

        case .deleteAccount:
            return .delete
            
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .contactUs(let dto):
            let params: [String: String] = [
                "receiver": dto.receiver,
                "category": dto.category,
                "body": dto.body
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
            
        case .deleteAccount(let dto):
            let params: [String: String] = [
                "revokerReason": dto.revokeReason
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .deleteAccount:
            let accesstoken = KeychainStorage.shared.accessToken
            
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accesstoken ?? "")",
                "sender": "app"
            ]
            
        default:
            let accessToken = KeychainStorage.shared.accessToken
            
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken ?? "")"
            ]
        }
    }
}
