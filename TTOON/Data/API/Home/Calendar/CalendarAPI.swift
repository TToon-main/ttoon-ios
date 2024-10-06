//
//  CalendarAPI.swift
//  TTOON
//
//  Created by 임승섭 on 9/23/24.
//

import Foundation
import Moya

enum CalendarAPI {
    case calendarThumbnail(yearMonth: String)
    case feedDetail(date: String)
    case deleteFeed(feedId: Int)
}

extension CalendarAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttoon.site")!
    }
    
    var path: String {
        switch self {
        case .calendarThumbnail:
            return "/api/home/calendar"
        case .feedDetail:
            return "/api/home"
        case .deleteFeed(let feedId):
            return "/api/delete/\(feedId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .calendarThumbnail, .feedDetail:
            return .get

        case .deleteFeed:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .calendarThumbnail(let yearMonth):
            let query = [
                "yearMonth": yearMonth
            ]
            return .requestParameters(
                parameters: query,
                encoding: URLEncoding.queryString
            )
            
        case .feedDetail(let date):
            let query = [
                "date": date
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
