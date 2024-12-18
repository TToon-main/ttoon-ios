//
//  DeleteAccountUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol DeleteAccountUseCaseProtocol {
    // 네트워크
    func deleteAccountRequest(_ requestModel: DeleteAccountRequestModel) -> Single<Result<Bool, Error>>
    func getUserInfo() -> Single<Result<UserInfoResponseModel, Error>>
    
    // 기타 로직
}

class DeleteAccountUseCase: DeleteAccountUseCaseProtocol {
    // 1. repo
    let repo: DeleteAccountRepositoryProtocol
    
    // 2. init
    init(_ repo: DeleteAccountRepositoryProtocol) {
        self.repo = repo
    }
    
    // 3-1. protocol method - network
    func deleteAccountRequest(_ requestModel: DeleteAccountRequestModel) -> Single<Result<Bool, Error>> {
        return repo.deleteAccountRequest(requestModel)
    }
    
    func getUserInfo() -> Single<Result<UserInfoResponseModel, Error>> {
        return repo.getUserInfo()
    }
    
    // 3-2. protocol method - logic
}
