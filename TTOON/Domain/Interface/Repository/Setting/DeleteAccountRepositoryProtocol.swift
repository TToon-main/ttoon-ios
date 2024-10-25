//
//  DeleteAccountRepositoryProtocol.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol DeleteAccountRepositoryProtocol {
    func deleteAccountRequest(_ requestModel: DeleteAccountRequestModel) -> Single<Result<Bool, Error>>
    func getNickname() -> Single<Result<String, Error>>
}
