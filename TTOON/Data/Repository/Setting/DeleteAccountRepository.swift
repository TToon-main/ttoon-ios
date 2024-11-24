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
    
    func getUserInfo() -> Single<Result<UserInfoResponseModel, Error>> {
        return Single<Result<UserInfoResponseModel, Error>>.create { single  in
            // 1. dto 없음
            
            // 2. 요청
            let request = self.provider.auth.request(.getUserInfo) { result in
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<UserInfoResponseDTO>.self),
                       data.isSuccess,
                       let responseData = data.data {
                        let infoModel: UserInfoResponseModel = responseData.toDomain()
                        single(.success(.success(infoModel)))
                    }
                    
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAccountRequest(_ requestModel: DeleteAccountRequestModel) -> Single<Result<Bool, Error>> {
        return Single<Result<Bool, Error>>.create { single  in
            // 1. dto 변환
            let requestDTO = DeleteAccountRequestDTO(requestModel)
            
            // 2. 요청
            let request = self.provider.unAuth.request(.deleteAccount(dto: requestDTO)) { result in
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
