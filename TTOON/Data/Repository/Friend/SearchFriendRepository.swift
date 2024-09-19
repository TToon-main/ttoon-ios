//
//  SearchFriendRepository.swift
//  TTOON
//
//  Created by 임승섭 on 9/8/24.
//

import Foundation
import RxCocoa
import RxSwift

// 1. 닉네임으로 유저 검색
// 2. 친구 추가

protocol SearchFriendRepositoryProtocol {
    func searchUserList(_ requestModel: UserListRequestModel) -> Single< Result<[SearchedUserInfoModel], Error> >
    func requestFriend(_ nickname: String) -> Single<Result<Bool, Error>>
}

class SearchFriendRepository: NSObject, SearchFriendRepositoryProtocol {
    private let provider = APIProvider<FriendAPI>()
    
    func searchUserList(_ requestModel: UserListRequestModel) -> RxSwift.Single<Result<[SearchedUserInfoModel], Error>> {
        return Single<Result<[SearchedUserInfoModel], Error>>.create { single in
            // 1. dto 변환
            let requestDTO = UserListRequestDTO(requestModel)
            
            // 2. 요청
            let request = self.provider.log.request(.userList(dto: requestDTO)) { result in
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<[SearchedUserInfoDTO]>.self),
                       data.isSuccess,
                       let responseData = data.data
                    {
                        // 성공
                        print("success : \(responseData)")
                        
                        let responseModel = responseData.map { $0.toDomain() }
                        
                        single(.success(.success(responseModel)))
                    }
                    
                    else {
                        print("****")
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
    
    func requestFriend(_ nickname: String) -> RxSwift.Single<Result<Bool, Error>> {
        return Single<Result<Bool, Error>>.create { single in
            // 1. dto 변환 없음
            
            // 2. 요청
            let request = self.provider.log.request(.reqeustFriend(nickname: nickname)) { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200 {
                        // 성공
                        single(.success(.success(true)))
                    } else {
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
