//
//  SetNickNameRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import Foundation

import RxSwift

class SetNickNameRepository: SetNickNameRepositoryProtocol {
    
    func postIsValidNickName(dto: PostIsValidNickNameRequestDTO) -> Observable<Event<Bool>> {
        let provider = APIProvider<LoginAPI>()
        
        return provider.auth.rx.request(.postIsValidNickName(dto: dto))
            .map(ResponseDTO<PostRefreshTokenResponseDTO>.self)
            .map{ $0.isSuccess }
            .asObservable()
            .materialize()
    }
}
