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
    func requestFriend(_ nickname: String) -> Single<Result<ReqeustFriendResult, Error>>
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
    
    func requestFriend(_ nickname: String) -> RxSwift.Single<Result<ReqeustFriendResult, Error>> {
        return Single<Result<ReqeustFriendResult, Error>>.create { single in
            // 1. dto 변환 없음
            
            // 2. 요청
            let request = self.provider.log.request(.reqeustFriend(nickname: nickname)) { result in
                switch result {
                // 이상한 점
                // Moya에서는 네트워크 통신 성공만 하면 무조건 success로 떨어지는 것으로 알고 있음
                // 근데, 둘 중 한 명이 이미 요청을 보냄 (400_5) 응답이 올 때, case.failure로 떨어짐
                // 일단 두 케이스에 모두 조건을 달아둠.
                    
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<Int>.self) {
                        // 1. 요청 성공
                        if data.code == "COMMON200" {
                            single(.success(.success(.success)))
                        }
                        
                        // 2. 이미 상대방이 요청 보낸 적 있음
                        else if data.code == "COMMON400_5" {
                            single(.success(.success(.alreadyReceivedRequest)))
                        }
                        
                        // 3. 실패
                        else {
                            single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                        }
                    }
                    
                    // 3. 실패
                    else {
                        single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    }
                    
                case .failure(let error):
                    if let response = error.response,
                       let data = try? JSONDecoder().decode(ResponseDTO<Int>.self, from: response.data) {
                        // 2. 이미 상대방이 요청 보낸 적 있음
                        if data.code == "COMMON400_5" {
                            single(.success(.success(.alreadyReceivedRequest)))
                        }
                        
                        // 4. 실패
                        else {
                            single(.success(.failure(error)))
                        }
                    }
                    
                    // 4. 실패
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}

enum ReqeustFriendResult {
    case success
    case alreadyReceivedRequest
}
