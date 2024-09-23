//
//  HomeCalendarRepository.swift
//  TTOON
//
//  Created by 임승섭 on 9/23/24.
//

import Foundation
import Moya
import RxSwift

protocol HomeCalendarRepositoryProtocol {
    func getCalendarThumbnails(_ yearMonth: String) -> Single<Result<[FeedThumbnailModel], Error>>
    func getFeedDetail(_ date: String) -> Single<Result<FeedModel, Error>>
}

class HomeCalendarRepository: NSObject,  HomeCalendarRepositoryProtocol {
    let provider = APIProvider<CalendarAPI>()
    
    func getCalendarThumbnails(_ yearMonth: String) -> Single<Result<[FeedThumbnailModel], Error>> {
        
        return Single<Result<[FeedThumbnailModel], Error>>.create { single in
            // 1. dto 변환 없음
            
            // 2. 요청
            let request = self.provider.log.request(.calendarThumbnail(yearMonth: yearMonth)) { result in
                
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<[FeedThumbnailDTO]>.self),
                       data.isSuccess,
                       let responseData = data.data
                    {
                        // 성공
                        let responseModel = responseData.map { $0.toDomain() }
                        single(.success(.success(responseModel)))
                        
                    } else {
                        // 실패 - (네트워크 통신은 성공했지만, statusCode가 200이 아닌 경우)
                        single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    }
                    
                case .failure(let moyaError):
                    // 실패 - (Moya 네트워크 통신 실패)
                    single(.success(.failure(moyaError)))
                }
            }
            return Disposables.create()
        }
    }
    
    
    func getFeedDetail(_ date: String) -> Single<Result<FeedModel, Error>> {
        
        return Single<Result<FeedModel, Error>>.create { single in
            // 1. dto 변환 없음
            
            // 2. 요청
            let request = self.provider.log.request(.feedDetail(date: date)) { result in
                
                switch result {
                case .success(let response):
                    if let data = try? response.map(ResponseDTO<FeedDTO>.self),
                       data.isSuccess,
                       let responseData = data.data {
                        // 성공
                        let responseModel = responseData.toDomain()
                        single(.success(.success(responseModel)))
                    } else {
                        // 실패
                        single(.success(.failure(SampleError(rawValue: response.statusCode)!)))
                    }
                    
                case .failure(let moyaError):
                    // 실패
                    single(.success(.failure(moyaError)))
                }
            }
            return Disposables.create()
        }
    }
}
