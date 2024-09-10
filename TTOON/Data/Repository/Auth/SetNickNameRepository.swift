//
//  SetNickNameRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import Foundation

import Moya
import RxSwift

class SetNickNameRepository: SetNickNameRepositoryProtocol {
    let provider = APIProvider<LoginAPI>()
    
    func postIsValidNickName(dto: PostIsValidNickNameRequestDTO) -> Observable<Event<Bool>> {
        return provider.log.rx.request(.postIsValidNickName(dto: dto))
            .map(ResponseDTO<PostRefreshTokenResponseDTO>.self)
            .map{ $0.isSuccess }
            .asObservable()
            .materialize()
    }
}
