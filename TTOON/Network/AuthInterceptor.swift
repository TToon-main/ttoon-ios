//
//  AuthInterceptor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/6/24.
//

import UIKit

import Alamofire
import Moya

final class Interceptor: RequestInterceptor {
    static let shared = Interceptor()
    private init() {}
    
    var appCoordinator: AppCoordinator?
    
    // adapt
    /// RequestAdapter 프로토콜의 구체적인 구현체
    /// urlRequest, session, completion을 파라미터로 전달
    /// KeyChain에 토큰이 있다면 -> header에 append후 hit request
    /// 없다면, 그냥 hit request
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        /// token이 없기 때문에, 토큰을 포함하지 않은 상태 그대로 request 전달
        guard let accessToken = KeychainStorage.shared.accessToken else {
            completion(.success(urlRequest))
            return
        }
        
        /// Token을 헤더에 포함한 request로 변형
        var authorizedUrlRequest = urlRequest
        
        authorizedUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        authorizedUrlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")        

        completion(.success(authorizedUrlRequest))
    }
    
    // adapt
    /// RequestRetrier 프로토콜의 구체적인 구현체
    /// urlRequest, session,error,  completion을 파라미터로 전달
    /// 401이 아닐 경우, 그냥 error 전달
    /// 401일 경우, refreshToken을 통해 갱신 시도
    /// 성공하면, 새로운 토큰으로 재요청
    /// 실패하면, 기존의 토큰 모두 삭제하고 LoginVC로 이동
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        /// 401에러가 아닐 경우, error 전달 
        guard let httpResponse = request.response,  
                httpResponse.statusCode == 401 
        else  {
            completion(.doNotRetryWithError(error))
            return  
        }
        
        /// refreshToken이 없을 경우,  error 전달
        guard let refreshToken = KeychainStorage.shared.refreshToken else {
            self.popToLoginVC()
            completion(.doNotRetryWithError(error))
            return 
        }
        
        /// refreshToken으로 Token 갱신 요청
        requestRefreshToken(refreshToken: refreshToken, completion)
    }
    
    private func requestRefreshToken(refreshToken: String, _ completion: @escaping (RetryResult) -> Void) {
        let accessToken = KeychainStorage.shared.accessToken ?? ""
        let dto = PostRefreshTokenRequestDTO(
            accessToken: accessToken,
            refreshToken: refreshToken)
        
        APIProvider<LoginAPI>().unAuth.request(.postRefreshToken(dto: dto)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = response.data
                    let responseDTO = try JSONDecoder().decode(ResponseDTO<PostRefreshTokenResponseDTO>.self, from: data)
                    
                    if let responseData = responseDTO.data {
                        let accessToken = responseData.accessToken
                        let refreshToken = responseData.refreshToken
                        
                        KeychainStorage.shared.accessToken = accessToken
                        KeychainStorage.shared.refreshToken = refreshToken
                        completion(.retry)
                    } else {
                        self.popToLoginVC()
                        completion(.doNotRetry)
                    }
                } catch {
                    self.popToLoginVC()
                    completion(.doNotRetryWithError(error))
                }

            case .failure(let error):
                self.popToLoginVC()
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
    private func popToLoginVC() {
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//            sceneDelegate.logout()
//        }
    }
} 
