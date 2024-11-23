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
    let toon: MoyaProvider<T> // 툰 생성을 위해 TimeOut 증가
    
    let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 1800
            
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
 
    init() {
        unAuth = MoyaProvider<T>()
        auth = MoyaProvider<T>(session: Session(interceptor: Interceptor.shared))
        log = MoyaProvider<T>(session: Session(interceptor: Interceptor.shared), plugins: [LogPlugin()])
        toon = MoyaProvider<T>(requestClosure: requestClosure, session: Session(interceptor: Interceptor.shared), plugins: [LogPlugin()])
    }
}
