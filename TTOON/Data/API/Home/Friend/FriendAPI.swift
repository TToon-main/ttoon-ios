//
//  FriendAPI.swift
//  TTOON
//
//  Created by 임승섭 on 8/25/24.
//

import Foundation
import Moya

enum FriendAPI {
    case friendList(page: Int) // 현재 내 친구 목록 조회
   
    case addFriend(nickname: String)  // 친구 추가
    
    case accptRequest(nickname: String)   // 친구 요청 수락
    case rejectRequest(nickname: String)  // 친구 요청 거절
        
    case deleteFriend(nickname: String)   // 친구 삭제
    // "친구 삭제"의 경우, "요청 거절"과 endpoint가 동일하지만, 편의를 위해 case 분리
    
    case userList(searchString: String, page: Int)   // 유저 리스트
}

extension FriendAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttoon.site")!
    }
    
    var path: String {
        switch self {
        case .friendList(let page):
            return "/api/friends?page=\(page)"
        case .addFriend, .rejectRequest, .deleteFriend:
            return "/api/friends"
        case .accptRequest(let nickname):
            return "/api/friends/\(nickname)"
        case .userList(let searchString, let page):
            return "예정"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .rejectRequest, .deleteFriend:
            return .delete

        case .friendList, .userList:
            return .get

        case .addFriend:
            return .post

        case .accptRequest:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
//        case .accptRequest, .friendList:
//            return .requestPlain
        
//        case .addFriend(let nickname), .rejectRequest(let nickname), case .deleteFriend(let nickname):
//            let params: [String: String] = [
//                "nickname": nickname
//            ]
//            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
            
        default:
            return .requestPlain
            
//        // 예정
//        case .userList(let searchString, let _):
//            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            let accessToken = KeychainStorage.shared.accessToken
            
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken ?? "")"
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
