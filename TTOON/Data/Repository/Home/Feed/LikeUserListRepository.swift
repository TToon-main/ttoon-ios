//
//  LikeUserListRepository.swift
//  TTOON
//
//  Created by 임승섭 on 10/31/24.
//

import Foundation
import RxSwift

protocol LikeUserListRepositoryProtocol {
    func getLikeUserList(_ feedId: Int) -> Single<Result<[UserInfoModel], Error>>
}
class LikeUserListRepository: NSObject, LikeUserListRepositoryProtocol {
    private let provider = APIProvider<FeedAPI>()
    
    func getLikeUserList(_ feedId: Int) -> Single<Result<[UserInfoModel], Error>> {
        return Single<Result<[UserInfoModel], Error>>.create { single in
            // 1. dto 변환 없음
            
            // 2. 요청
            let request = self.provider.log.request(.likeUserList(feedId: feedId)) { result in
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<[LikeUserDTO]>.self),
                       data.isSuccess,
                       let responseData = data.data {
                        // 성공
                        let responseModel = responseData.map { $0.toDomain() }
                        single(.success(.success(responseModel)))
                    }
                    else {
                        // 실패
                        single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    }
                    
                case .failure(let error):
                    // 실패
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}
