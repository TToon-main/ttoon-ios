//
//  SplashAPI.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/6/24.
//

import Foundation

import Moya

// API 타겟 정의
enum SplashAPI {
    case getMinVersion
}

extension SplashAPI: TargetType {
    // baseURL
    var baseURL: URL {
        return URL(string: "https://ttoon.site")! 
    }
    
    // switch self를 통해, 각 타겟에 대한 엔드포인트 지정
    var path: String {
        switch self {
        case.getMinVersion:
            return "/api/auth/version" 
        }
    }
    
    // switch self를 통해, 각 타겟에 대한 http 메서드 지정
    var method: Moya.Method {
        switch self {
        case .getMinVersion:
            return .get
        }
    }
    
    // switch self를 통해, 각 타겟에 파라미터 지정
    var task: Moya.Task {
        switch self {
        case .getMinVersion:
            return .requestPlain
        }
    }
    
    // switch self를 통해, 각 타겟에 헤더 지정
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
