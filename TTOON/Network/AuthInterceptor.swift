//
//  AuthInterceptor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/6/24.
//

import Foundation

import Moya
import RxSwift

final class Interceptor: RequestInterceptor {
    static let shared = Interceptor()
    private let disposeBag = DisposeBag()
    private init() {}
    
    // TODO: 인터셉터 구현
    
//    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
//            return
//        }
//        
//        guard urlRequest.url?.absoluteString.hasPrefix(baseURL) == true, let accessToken = KeyChain.read(key: Constant.KeyChainKey.accessToken) else {
//            completion(.success(urlRequest))
//            return
//        }
//
//        var urlRequest = urlRequest
//        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        completion(.success(urlRequest))
//    }
//    
//    func retry(_ request: Request, for _: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        guard let response = request.response, response.statusCode == 401 else {
//            completion(.doNotRetryWithError(error))
//            return
//        }
//        
//        guard let refreshToken = KeyChain.read(key: Constant.KeyChainKey.refreshToken) else {
//            return
//        }
//        
//        let obsavable = LaunchScreenViewModel().checkRefreshToken(refreshToken)
//        obsavable.subscribe(with: self) { _, result in
//            switch result {
//            case .success:
//                completion(.retry)
//
//            case .failure:
//                AppDelegate.shared.presentStartScreen()
//                completion(.doNotRetryWithError(error))
//            }
//        }
//        .disposed(by: disposeBag)
//    }
}
