//
//  SearchFriendUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 9/8/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol SearchFriendUseCaseProtocol {
    // 네트워크
    func searchUserList(_ requestModel: UserListRequestModel) -> Single< Result<[SearchedUserInfoModel], Error> >
    func requestFriend(_ nickname: String) -> Single<Result<Bool, Error>>
}

class SearchFriendUseCase: SearchFriendUseCaseProtocol {
    // 1. repo
    let repo: SearchFriendRepositoryProtocol
    
    // 2. init
    init(_ repo: SearchFriendRepositoryProtocol) {
        self.repo = repo
    }
    
    // 3 - 1. protocol method - network
    func searchUserList(_ requestModel: UserListRequestModel) -> RxSwift.Single<Result<[SearchedUserInfoModel], Error>> {
        return repo.searchUserList(requestModel)
    }
    
    func requestFriend(_ nickname: String) -> RxSwift.Single<Result<Bool, Error>> {
        return repo.requestFriend(nickname)
    }
    
    // 3 - 2. protocol method - logic
}
