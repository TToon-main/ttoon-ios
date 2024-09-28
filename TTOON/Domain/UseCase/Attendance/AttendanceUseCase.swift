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
    func fetchAttendanceResult() -> Observable<AttendanceUseCase.AttendanceResult>
}

class AttendanceUseCase: AttendanceUseCaseProtocol {
    let repo: AttendanceRepositoryProtocol
    
    enum CheckAttendance {
        case valid(status: GetAttendanceResponseDTO)
        case inValid
    }
    
    enum AttendanceResult {
        case success
        case alreadyDone
        case unknown
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
    
    func fetchAttendanceResult() -> Observable<AttendanceResult> {
        let request = repo.postAttendance().share()
        
        let success = request
            .compactMap { $0.element }
            .do { _ in print("디버그 fetchAttendanceResult 성공")}
            .filter { $0 }
            .map { _ in AttendanceResult.success }
        
        let error = request
            .compactMap { $0.error }
            .do { _ in print("디버그 fetchAttendanceResult 실패")}
            .map { $0 as? AttendanceRepository.PostAttendanceError ?? .unknown }
            .map { e in
                switch e {
                case .alreadyDone:
                    return AttendanceResult.alreadyDone

                default:
                    return AttendanceResult.unknown
                }
            }
        
        
            
        return .merge(success, error)
    }
}
