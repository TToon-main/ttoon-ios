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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .feedList:
            return .get

        case .addLike:
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
