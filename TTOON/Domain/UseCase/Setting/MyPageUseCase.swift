//
//  MyPageUseCase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import UIKit

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
    
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
    
    func truncateText(_ text: String, limit: Int = 10) -> String {
        ValidationManager.shared.truncateText(text, limit: limit)
    }
}
