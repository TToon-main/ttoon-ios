//
//  LikeUserListUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 10/31/24.
//

import Foundation
import RxSwift

protocol LikeUserListUseCaseProtocol {
    // 네트워크
    func getLikeUserList(_ feedId: Int) -> Single<Result<[UserInfoModel], Error>>
}
class LikeUserListUseCase: LikeUserListUseCaseProtocol {
    // 1. repo
    let repo: LikeUserListRepositoryProtocol
    
    // 2. init
    init(_ repo: LikeUserListRepositoryProtocol) {
        self.repo = repo
    }
    
    // 3 - 1. protocol method - network
    func getLikeUserList(_ feedId: Int) -> RxSwift.Single<Result<[UserInfoModel], Error>> {
        return repo.getLikeUserList(feedId)
    }
}
