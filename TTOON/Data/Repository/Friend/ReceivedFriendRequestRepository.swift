//
//  ReceivedFriendRequestRepository.swift
//  TTOON
//
//  Created by 임승섭 on 9/8/24.
//

import Foundation
import RxCocoa
import RxSwift

/*
 2. 받은 요청
 - 친구 요청 목록 조회
     - query : page
     - response : {friendId, profileUrl, nickname}
 - 친구 요청 수락
     - query : friendId
     - response : x
 - 친구 요청 거절
     - query : friendId
     - response : x
 */

protocol ReceivedFriendRequestRepositoryProtocol {
    func receivedRequestList(_ page: Int) -> Single<Result<[UserInfoModel], Error>>
    func acceptFriendRequest(_ friendId: Int) -> Single<Result<Bool, Error>>
    func rejectFriendRequest(_ friendId: Int) -> Single<Result<Bool, Error>>
}

class ReceivedFriendRequestRepository: NSObject, ReceivedFriendRequestRepositoryProtocol {
    private let provider = APIProvider<FriendAPI>()
    
    func receivedRequestList(_ page: Int) -> RxSwift.Single<Result<[UserInfoModel], Error>> {
        return Single<Result<[UserInfoModel], Error>>.create { single in
            // 1. dto 변환 없음
            
            // 2. 요청
            let request = self.provider.auth.request(.receivedRequestList(page: page)) { result in
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<[UserInfoDTO]>.self),
                       data.isSuccess,
                       let responseData = data.data
                    {
                        // 성공
                        print("success : \(responseData)")
                        
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
    
    func acceptFriendRequest(_ friendId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return Single<Result<Bool, Error>>.create { single in
            // 1. dto 변환 없음
            
            // 2. 요청
            let request = self.provider.auth.request(.acceptRequest(friendID: friendId)) { result in
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
    
    func rejectFriendRequest(_ friendId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return Single<Result<Bool, Error>>.create { single in
            // 1. dto 변환 없음
            
            // 2. 요청
            let request = self.provider.auth.request(.rejectRequest(friendID: friendId)) { result in
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
