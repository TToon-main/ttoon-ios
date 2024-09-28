//
//  AttendanceRepositoryProtocol.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import Foundation

import RxSwift

protocol AttendanceRepositoryProtocol {
    func getAttendance() -> Observable<Event<GetAttendanceResponseDTO>> 
}
