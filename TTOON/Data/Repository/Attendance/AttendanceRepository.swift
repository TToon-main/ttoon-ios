//
//  AttendanceRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import Foundation

import RxMoya
import RxSwift

class AttendanceRepository: AttendanceRepositoryProtocol {    
    let provider = APIProvider<AttendanceAPI>()
    
    func getAttendance() -> Observable<Event<GetAttendanceResponseDTO>> { 
        return provider.log.rx.request(.getAttendance)
            .mapData(responseType: GetAttendanceResponseDTO.self,
                        errorType: GetAttendanceError.self)
    }
    
    func postAttendance() -> Observable<Event<Bool>> {
        return provider.log.rx.request(.postAttendance)
            .mapIsSuccess(errorType: PostAttendanceError.self)
    }
}

extension AttendanceRepository {
    enum GetAttendanceError: String, CommonErrorProtocol {
        case unknown
        case decoding
    }
    
    enum PostAttendanceError: String, CommonErrorProtocol {
        case alreadyDone = "COMMON400_8"
        case unknown
        case decoding
    }
}
