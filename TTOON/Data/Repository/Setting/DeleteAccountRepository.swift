//
//  DeleteAccountRepository.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation
import RxCocoa
import RxSwift

class DeleteAccountRepository: DeleteAccountRepositoryProtocol {
    private let provider = APIProvider<SettingAPI>()
    
    func deleteAccountRequest(_ requestModel: DeleteAccountRequestModel) -> Single<Result<Bool, Error>> {
        return Single<Result<Bool, Error>>.create { single  in
            // 1. dto 변환
            let requestDTO = DeleteAccountRequestDTO(requestModel)
            
            // 2. 요청
            let request = self.provider.auth.request(.deleteAccount(dto: requestDTO)) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        single(.success(.success(true)))
                    } else {
                        single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    }
                    
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            
            return Disposables.create()
        }
    }
}
