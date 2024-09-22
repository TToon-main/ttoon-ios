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
}

extension AttendanceAPI: TargetType {
    // baseURL
    var baseURL: URL {
        return URL(string: "https://ttoon.site")! 
    }
    
    // switch self를 통해, 각 타겟에 대한 엔드포인트 지정
    var path: String {
        switch self {
        case.getAttendance:
            return "/api/attendance" 
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAttendance:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAttendance:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        nil
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
