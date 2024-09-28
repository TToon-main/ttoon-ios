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
        case valid(status: GetAttendanceResponseDTO) // 조회 성공
        case inValid // 조회 실패 -> 추후에 조회에 실했습니다 ~ 재시도 해주세요 같은 화면 들어가면 좋을듯
    }
    
    enum AttendanceResult {
        case success // 성공
        case alreadyDone // 이미 출석체크 됨
        case unknown // 알 수 없는 에러
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
            .filter { $0 }
            .map { _ in AttendanceResult.success }
        
        let error = request
            .map { $0.error }
            .mapError(AttendanceRepository.PostAttendanceError.self)
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
