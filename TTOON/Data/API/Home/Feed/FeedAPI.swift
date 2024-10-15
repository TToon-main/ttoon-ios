//
//  FeedAPI.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import Foundation
import Moya

enum FeedAPI {
    case feedList(onlyMine: Bool, page: Int)
    case addLike(feedId: Int)
    case deleteLike(feedId: Int)
    case deleteFeed(feedId: Int)
    case contactUs(dto: ContactUsRequestDTO)    // 신고하기에서 사용
}

extension FeedAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttoon.site")!
    }
    
    var path: String {
        switch self {
        case .feedList:
            return "/api/feeds"
        case .addLike(let feedId):
            return "/api/likes/\(feedId)"
        case .deleteLike(let feedId):
            return "/api/likes/\(feedId)"
        case .deleteFeed(let feedId):
            return "/api/delete/\(feedId)"
        case .contactUs:
            return "/api/ask"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .feedList:
            return .get

        case .addLike, .contactUs:
            return .post

        case .deleteLike, .deleteFeed:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .feedList(let onlyMine, let page):
            let query: [String: Any] = [
                "page": page,
                "size": 20,
                "onlyMine": onlyMine
            ]
            return .requestParameters(
                parameters: query,
                encoding: URLEncoding.queryString
            )
            
        case .contactUs(let dto):
            let params: [String: String] = [
                "receiver": dto.receiver,
                "category": dto.category,
                "body": dto.body
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)

        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
