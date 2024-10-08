//
//  HomeFeedRepository.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import Foundation
import Moya
import RxSwift

protocol HomeFeedRepositoryProtocol {
    func getFeedList(onlyMine: Bool, page: Int) -> Single<Result<[FeedWithInfoModel], Error>>
    func addLikeToFeed(feedId: Int) -> Single<Result<Bool, Error>>
    func deleteLikeToFeed(feedId: Int) -> Single<Result<Bool, Error>>
    func deleteFeed(feedId: Int) -> Single<Result<Bool, Error>>
}

class HomeFeedRepository: HomeFeedRepositoryProtocol {
    let provider = APIProvider<FeedAPI>()

    func getFeedList(onlyMine: Bool, page: Int) -> RxSwift.Single<Result<[FeedWithInfoModel], Error>> {
        return Single<Result<[FeedWithInfoModel], Error>>.create { single in
            let request = self.provider.log.request(.feedList(onlyMine: onlyMine, page: page)) { result in
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<[FeedWithInfoDTO]>.self),
                       data.isSuccess,
                       let responseData = data.data {
                        // 성공
                        let responseModel = responseData.map { $0.toDomain() }
                        single(.success(.success(responseModel)))
                    } else {
                        single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    }
                    
                case .failure(let moyaError):
                    single(.success(.failure(moyaError)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func addLikeToFeed(feedId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return Single<Result<Bool, Error>>.create { single in
            let request = self.provider.log.request(.addLike(feedId: feedId)) { result in
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<Bool>.self),
                       data.isSuccess {
                        single(.success(.success(true)))
                    }
                    single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteLikeToFeed(feedId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return Single<Result<Bool, Error>>.create { single in
            let request = self.provider.log.request(.deleteLike(feedId: feedId)) { result in
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<Bool>.self),
                       data.isSuccess {
                        single(.success(.success(true)))
                    }
                    single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteFeed(feedId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return Single<Result<Bool, Error>>.create { single in
            let request = self.provider.log.request(.deleteFeed(feedId: feedId)) { result in
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<Bool>.self),
                       data.isSuccess {
                        single(.success(.success(true)))
                    }
                    single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}
