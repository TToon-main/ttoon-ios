//
//  Single+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/28/24.
//

import UIKit

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapData<T: Codable, E: CommonErrorProtocol>(responseType: T.Type, errorType: E.Type) -> Observable<Event<T>> {
        return flatMap { response -> Single<T> in
            let decodedResponse = try response.map(ResponseDTO<T>.self)
            
            /// 성공 여부와 401 에러 여부 확인
            let isSuccess = decodedResponse.isSuccess
            let isUnauthorized = check401Error(response: response)
            
            /// 성공에 대한 응답 data
            let data = decodedResponse.data
            
            /// 성공하지 않은 경우 처리
            guard isSuccess else {
                /// 토큰 이슈
                if isUnauthorized {
                    requestRefreshToken()
                }
                
                throw E(rawValue: decodedResponse.code) ?? E.unknown
            }
            
            guard let data = data else {
                throw E.unknown
            }
            
            return .just(data) /// 성공한 경우
        }
        .asObservable()
        .materialize()
    }
    
    /// ResponseDTO에 data 필드가 비어 있는 경우
    /// 성공에 별도의 응답 data가 없는 경우
    func mapIsSuccess<E: CommonErrorProtocol>(errorType: E.Type) -> Observable<Event<Bool>> {
        return flatMap { response -> Single<Bool> in
            let decodedResponse = try response.map(ResponseDTO<Bool>.self)
            
            /// 성공 여부와 401 에러 여부 확인
            let isSuccess = decodedResponse.isSuccess
            let isUnauthorized = check401Error(response: response)
            
            /// 성공하지 않은 경우 처리
            guard isSuccess else {
                /// 토큰 이슈
                if isUnauthorized {
                    requestRefreshToken()
                }
                throw E(rawValue: decodedResponse.code) ?? E.unknown
            }
            
            return .just(isSuccess) /// 성공한 경우
        }
        .asObservable()
        .materialize()
    }
    
    private func check401Error(response: Response) -> Bool {
        let statusCode = response.statusCode
        let is401 = statusCode == 401
        
        return is401
    }
    
    private func requestRefreshToken() {
        guard let refreshToken = KeychainStorage.shared.refreshToken else {
            self.popToLoginVC()
            return
        }
        
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
                    } else {
                        self.popToLoginVC()
                    }
                } catch {
                    self.popToLoginVC()
                }
                
            case .failure:
                self.popToLoginVC()
            }
        }
    }
    
    private func popToLoginVC() {
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.logout()
            }
        }
    }
}
