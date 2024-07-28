//
//  ContactUsRepository.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation
import RxCocoa
import RxSwift



class ContactUsRepository: NSObject, ContactUsRepositoryProtocol {
    private let provider = APIProvider<SettingAPI>()
    
    func contactUsRequest(_ requestModel: ContactUsRequestModel) -> Single<Result<Bool, Error>> {
        return Single< Result< Bool, Error> >.create { single in
            // 1. dto 변환
            let requestDTO = ContactUsRequestDTO(requestModel)
            
            // 2. 요청
            let request = self.provider.auth.request(.contactUs(dto: requestDTO)) { result in
                switch result {
                case .success(let response):
                    // 모야는 서버 통신이 성공하기만 하면 success
                    if response.statusCode == 200 {
                        single(.success(.success(true)))    // 응답 데이터가 없다.
                    } else {
                        // statusCode에 따라 에러 RawValue로 만들어서 넘겨주기
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


// 샘플 에러. 에러 구조가 잡히기 전에는 계속 활용
enum SampleError: Int, Error {
    case sample400 = 400
    case sample401 = 401
}
