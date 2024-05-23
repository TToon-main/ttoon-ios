//
//  APIProvider.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/6/24.
//

import Foundation

import Moya

class APIProvider<T: TargetType> {
    let unAuth: MoyaProvider<T> // AuthInterceptor가 필요 없는 경우
    let auth: MoyaProvider<T> // AuthInterceptor 추가
    let log: MoyaProvider<T> // 로깅 Plugin 추가
 
    init() {
        unAuth = MoyaProvider<T>()
        auth = MoyaProvider<T>(session: Session(interceptor: Interceptor.shared))
        log = MoyaProvider<T>(session: Session(interceptor: Interceptor.shared), plugins: [LogPlugin()])
    }
}
