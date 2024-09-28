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


// 1. 캘린더 썸네일 조회
// [GET] ~/api/home/callender?yearMonth=2024-06
// {
//  "isSuccess": true,
//  "code": "COMMON200",
//  "message": "요청에 성공하였습니다.",
//  "data": {
//      {
//      "thumnailList" : [
//          {
//                "id" : 1,
//                "createdDate" : 2024-06-02,
//                "thumnailUrl" : "anfvalvnaldlajf"
//            },
//            {
//                "id" : 2,
//                "createdDate" : 2024-06-04,
//                "thumnailUrl" : "anfvalvnaldlajf"
//            },
//            {
//                "id" : 3,
//                "createdDate" : 2024-06-10,
//                "thumnailUrl" : "anfvalvnaldlajf"
//            }
//      ]
//  }
// }


// 2. 피드 단일 조회
// [GET] ~/api/home?dates=2024-05-20
// {
//  "isSuccess": true,
//  "code": "COMMON200",
//  "message": "요청에 성공하였습니다.",
//  "data": {
//            "id" : 1,
//            "title" : "일본 여행",
//            "imageList" : [
//                {
//                    "imageUrl" : "ajdsvoiandocmalkecal"
//                },
//                {
//                    "imageUrl" : "oijgoidjknvkajdnvao"
//                },
//                {
//                    "imageUrl" : "oijgoidjknvkajdnvao"
//                },
//                {
//                    "imageUrl" : "oijgoidjknvkajdnvao"
//                }
//            ],
//            "content" : "일본을 다녀왔는데...",
//            "createDate" : 2024-06-05,
//            "like" : 12
//    }
// }
