//
//  AttendanceAPI.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import Foundation

import Moya

enum AttendanceAPI {
    case getAttendance
    case postAttendance
}

extension AttendanceAPI: TargetType {
    // baseURL
    var baseURL: URL {
        return URL(string: "https://ttoon.site")! 
    }
    
    // switch self를 통해, 각 타겟에 대한 엔드포인트 지정
    var path: String {
        switch self {
        case.getAttendance, .postAttendance:
            return "/api/attendance"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAttendance:
            return .get

        case .postAttendance:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAttendance, .postAttendance:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        nil
    }
}
