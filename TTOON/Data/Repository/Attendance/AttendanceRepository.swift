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
            .map(GetAttendanceResponseDTO.self)
            .asObservable()
            .materialize()
    }
}
