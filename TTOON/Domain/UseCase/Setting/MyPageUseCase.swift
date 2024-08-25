//
//  MyPageUseCase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import Foundation

import RxSwift

class MyPageUseCase {
    let repository: MyPageRepository
    
    init(repository: MyPageRepository) {
        self.repository = repository
    }
    
    func getUserInfo() -> Observable<Event<UserInfoResponseModel>> {
        return repository.getUserInfo()
            .map { $0.toDomain() }
            .materialize()
    }
    
    func getProfileInfo() -> Observable<Event<SetProfileResponseModel>> {
        return repository.getUserInfo()
            .map { $0.toDomain() }
            .materialize()
    }
}
