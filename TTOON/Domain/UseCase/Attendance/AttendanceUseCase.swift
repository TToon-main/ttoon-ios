//
//  AttendanceUseCase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import Foundation

import RxSwift

protocol AttendanceUseCaseProtocol {    
    func checkAttendance() -> Observable<AttendanceUseCase.CheckAttendance> 
}

class AttendanceUseCase: AttendanceUseCaseProtocol {
    let repo: AttendanceRepositoryProtocol
    
    enum CheckAttendance {
        case valid(status: GetAttendanceResponseDTO)
        case inValid
    }
    
    init(repo: AttendanceRepositoryProtocol) {
        self.repo = repo
    }
    
    func checkAttendance() -> Observable<CheckAttendance> {
        let request = repo.getAttendance().share()

        let success = request
            .compactMap { $0.element }
            .map {  CheckAttendance.valid(status: $0) }
        
        let fail = request
            .compactMap { $0.error }
            .map { _ in CheckAttendance.inValid }

        return .merge(success, fail)  
    }
}
