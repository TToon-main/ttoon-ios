//
//  APIProvider.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/6/24.
//

import Foundation

import Moya

class APIProvider<T: TargetType> {
    let unAuthProvider: MoyaProvider<T> // AuthInterceptor가 필요 없는 경우 
    let provider: MoyaProvider<T> // AuthInterceptor 추가
    let logProvider: MoyaProvider<T> // 로깅 Plugin 추가
 
    init() {
        unAuthProvider = MoyaProvider<T>()
        provider = MoyaProvider<T>(session: Session(interceptor: AuthInterceptor.shared))
        logProvider = MoyaProvider<T>(session: Session(interceptor: AuthInterceptor.shared), plugins: [LogPlugin()])
    }
}
