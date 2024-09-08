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
   
    case reqeustFriend(nickname: String)  // 친구 추가
    
    case acceptRequest(friendID: Int)   // 친구 요청 수락
    case rejectRequest(friendID: Int)  // 친구 요청 거절
        
    case deleteFriend(friendID: Int)   // 친구 삭제
    // "친구 삭제"의 경우, "요청 거절"과 endpoint가 동일하지만, 편의를 위해 case 분리
    
    case userList(dto: UserListRequestDTO)   // 유저 리스트
    
    case receivedRequestList(page: Int) // 받은 친구 요청 목록 조회
}

extension FriendAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttoon.site")!
    }
    
    var path: String {
        switch self {
        case .friendList:
            return "/api/friends"  // Moya에서는 쿼리로 requestParameter로 넣어줘야 함
        case .reqeustFriend:
            return "/api/friends"
            
        case .acceptRequest(let friendID):
            return "/api/friends/\(friendID)"
            
        case .rejectRequest(let friendID):
            return "/api/friends/\(friendID)"
            
        case .deleteFriend(let friendID):
            return "/api/friends/\(friendID)"
            
        case .userList:
            return "/api/search"
            
        case .receivedRequestList:
            return "/api/friends/asks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .rejectRequest, .deleteFriend:
            return .delete

        case .friendList, .userList, .receivedRequestList:
            return .get

        case .reqeustFriend:
            return .post

        case .acceptRequest:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .friendList(let page):
            let query = [
                "page": page
            ]
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
            
        case .reqeustFriend(let nickname):
            let params: [String: String] = [
                    "nickname": nickname
                ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
            
        case .userList(let dto):
            let query = [
                "name": dto.searchStr,
                "page": dto.page
            ] as [String: Any]
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
            
        case .receivedRequestList(let page):
            let query = [
                "page": page
            ]
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            let accessToken = KeychainStorage.shared.accessToken
            print("accessToken : \(accessToken ?? "")")
            
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
