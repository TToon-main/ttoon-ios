//
//  HomeFeedUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import Foundation
import RxSwift

protocol HomeFeedUseCaseProtocol {
    func getFeedList(onlyMine: Bool, page: Int) -> Single<Result<[FeedWithInfoModel], Error>>
    func addLikeToFeed(feedId: Int) -> Single<Result<Bool, Error>>
    func deleteLikeToFeed(feedId: Int) -> Single<Result<Bool, Error>>
    func deleteFeed(feedId: Int) -> Single<Result<Bool, Error>>
}

class HomeFeedUseCase: HomeFeedUseCaseProtocol {
    // 1. repo
    let repo: HomeFeedRepositoryProtocol
    
    // 2. init
    init(_ repo: HomeFeedRepositoryProtocol) {
        self.repo = repo
    }
    
    func getFeedList(onlyMine: Bool, page: Int) -> RxSwift.Single<Result<[FeedWithInfoModel], Error>> {
        return repo.getFeedList(onlyMine: onlyMine, page: page)
    }
    
    func addLikeToFeed(feedId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return repo.addLikeToFeed(feedId: feedId)
    }
    
    func deleteLikeToFeed(feedId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return repo.deleteLikeToFeed(feedId: feedId)
    }
    
    func deleteFeed(feedId: Int) -> RxSwift.Single<Result<Bool, Error>> {
        return repo.deleteFeed(feedId: feedId)
    }
}
