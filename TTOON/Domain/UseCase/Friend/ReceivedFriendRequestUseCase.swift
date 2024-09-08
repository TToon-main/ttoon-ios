//
//  ReceivedFriendRequestUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 9/8/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol ReceivedFriendRequestUseCaseProtocol {
    // 네트워크
    func receivedRequestList(_ page: Int) -> Single<Result<[UserInfoModel], Error>>
    func acceptFriendRequest(_ friendId: Int) -> Single<Result<Bool, Error>>
    func rejectFriendRequest(_ friendId: Int) -> Single<Result<Bool, Error>>
}

class ReceivedFriendRequestUseCase: ReceivedFriendRequestUseCaseProtocol {
    // 1. repo
    let repo: ReceivedFriendRequestRepositoryProtocol
    
    // 2. init
    init(_ repo: ReceivedFriendRequestRepositoryProtocol) {
        self.repo = repo
    }
    
    // 3 - 1. protocol method - network
    func receivedRequestList(_ page: Int) -> RxSwift.Single<Result<[UserInfoModel], Error>> {
        return repo.receivedRequestList(page)
    }
    
    func acceptFriendRequest(_ friendId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return repo.acceptFriendRequest(friendId)
    }
    
    func rejectFriendRequest(_ friendId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return repo.rejectFriendRequest(friendId)
    }
    
    
    
    // 3 - 2. protocol method - logic
}
