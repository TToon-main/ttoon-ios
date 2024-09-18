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
    case patchProfile(dto: PatchProfileRequestDTO)
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
        case .patchProfile:
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
            
        case .patchProfile:
            return .patch
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
            
        case .patchProfile(let dto):
            
            var multipartData: [MultipartFormData] = []
            
            if let image = dto.image,
               let imageData = image.jpegData(compressionQuality: 0.1) {
                multipartData.append(MultipartFormData(provider: .data(imageData), name: "file", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg"))
            }
            
            let params: [String: Any] = [
                "nickName": dto.nickName,
                "isDelete": dto.isDelete
            ]
            
            if multipartData.isEmpty {
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            } else {
                return .uploadCompositeMultipart(multipartData, urlParameters: params)
            }

        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .deleteAccount:
            return [ "sender": "app"]
            
        case .patchProfile(let dto):
            let token = KeychainStorage.shared.accessToken ?? "" 

            if dto.image == nil {
                return [
                    "Content-Type": "application/application/json",
                    "Authorization": "Bearer \(token)"
                ]
            } else {
                return [
                    "Content-Type": "multipart/form-data",
                    "Authorization": "Bearer \(token)"
                ]
            }
            
        default:
            return nil
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
