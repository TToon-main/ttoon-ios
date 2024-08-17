//
//  ContactUsUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol ContactUsUseCaseProtocol {
    // 네트워크
    func contactUsRequest(_ requestModel: ContactUsRequestModel) -> Single<Result<Bool, Error>>
    
    // 기타 로직
}

class ContactUsUseCase: ContactUsUseCaseProtocol {
    // 1. repo
    let repo: ContactUsRepositoryProtocol
    
    // 2. init
    init(_ repo: ContactUsRepositoryProtocol) {
        self.repo = repo
    }
    
    // 3-1. protocol method - network
    func contactUsRequest(_ requestModel: ContactUsRequestModel) -> Single<Result<Bool, Error>> {
        return repo.contactUsRequest(requestModel)
    }
    
    // 3-2. protocol method - logic
}
