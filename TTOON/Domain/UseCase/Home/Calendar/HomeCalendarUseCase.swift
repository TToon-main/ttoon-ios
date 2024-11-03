//
//  HomeCalendarUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 9/23/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeCalendarUseCaseProtocol {
    func getCalendarThumbnails(_ yearMonth: String) -> Single<Result<[FeedThumbnailModel], Error>>
    func getFeedDetail(_ date: String) -> Single<Result<FeedModel, Error>>
    func deleteFeed(_ feedId: Int) -> Single<Result<Bool, Error>>
}

class HomeCalendarUseCase: HomeCalendarUseCaseProtocol {
    // 1. repo
    let repo: HomeCalendarRepositoryProtocol
    
    // 2. init
    init(_ repo: HomeCalendarRepositoryProtocol) {
        self.repo = repo
    }
    
    // 3 - 1. protocol method - network
    func getCalendarThumbnails(_ yearMonth: String) -> RxSwift.Single<Result<[FeedThumbnailModel], Error>> {
        return repo.getCalendarThumbnails(yearMonth)
    }
    
    func getFeedDetail(_ date: String) -> RxSwift.Single<Result<FeedModel, Error>> {
        return repo.getFeedDetail(date)
    }
    
    func deleteFeed(_ feedId: Int) -> Single<Result<Bool, Error>> {
        return repo.deleteFeed(feedId)
    }
}
