//
//  FriendListUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 9/8/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol FriendListUseCaseProtocol {
    // 네트워크
    func requestFriendList(_ page: Int) -> Single<Result<[UserInfoModel], Error>>
    func deleteFriend(_ friendId: Int) -> Single<Result<Bool, Error>>
}

class FriendListUseCase: FriendListUseCaseProtocol {
    // 1. repo
    let repo: FriendListRepositoryProtocol
    
    // 2. init
    init(_ repo: FriendListRepositoryProtocol) {
        self.repo = repo
    }
    
    // 3 - 1. protocol method - network
    func requestFriendList(_ page: Int) -> RxSwift.Single<Result<[UserInfoModel], Error>> {
        return repo.requestFriendList(page)
    }
    
    func deleteFriend(_ friendId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return repo.deleteFriend(friendId)
    }
    
    
    // 3 - 2. protocol method - logic
}
