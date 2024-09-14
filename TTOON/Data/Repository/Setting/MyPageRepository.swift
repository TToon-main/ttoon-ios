//
//  MyPageRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import Foundation

import Moya
import RxSwift

class MyPageRepository: MyPageRepositoryProtocol {
    let provider = APIProvider<SettingAPI>()
    
    func getUserInfo() -> Observable<UserInfoResponseDTO> {
        return provider.auth.rx.request(.getUserInfo)
            .map(ResponseDTO<UserInfoResponseDTO>.self)
            .compactMap{ $0.data }
            .asObservable()
    }
    
    func patchProfile(dto: PatchProfileRequestDTO) -> Observable<Bool> {
        return provider.unAuth.rx.request(.patchProfile(dto: dto))
            .map(ResponseDTO<String>.self)
            .map { $0.isSuccess }
            .asObservable()
    }
}
