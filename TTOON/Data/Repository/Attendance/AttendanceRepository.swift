//
//  AttendanceRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

class AttendanceRepository: AttendanceRepositoryProtocol {    
    let provider = APIProvider<AttendanceAPI>()
    
    func getAttendance() -> Observable<Event<GetAttendanceResponseDTO>> { 
        return provider.log.rx.request(.getAttendance)
            .catchError(responseType: GetAttendanceResponseDTO.self,
                        errorType: GetAttendanceError.self)
            .compactMap{ $0.data }
            .asObservable()
            .materialize()
    }
    
    func postAttendance() -> Observable<Event<Bool>> {
        return provider.log.rx.request(.postAttendance)
            .catchError(responseType: Bool.self,
                        errorType: GetAttendanceError.self)
            .compactMap{ $0.isSuccess }
            .asObservable()
            .materialize()
    }
}

extension AttendanceRepository {
    enum GetAttendanceError: String, CommonErrorProtocol {
        case unknown
        case decoding
    }
    
    enum PostAttendanceError: String, Error {
        case alreadyDone = "COMMON400"
        case unknown
        case decoding
    }
}

protocol CommonErrorProtocol: Error, RawRepresentable where RawValue == String {
    static var decoding: Self { get }
    static var unknown: Self { get }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func catchError<T: Codable, E: CommonErrorProtocol>(responseType: T.Type, errorType: E.Type) -> Single<ResponseDTO<T>> {
        return flatMap { response -> Single<ResponseDTO<T>> in
            var error: ResponseDTO<T>
            
            guard (200 ... 299).contains(response.statusCode) else {
                do {
                    error = try response.map(ResponseDTO<T>.self)
                } catch {
                    throw E.decoding
                }
                throw E(rawValue: error.code) ?? E.unknown
            }
            
            let decodedResponse = try response.map(ResponseDTO<T>.self)
            return .just(decodedResponse)
        }
    }
}
