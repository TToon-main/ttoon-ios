//
//  AttendanceReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import Foundation

import ReactorKit
import RxSwift

final class AttendanceReactor: Reactor {  
    private let useCase: AttendanceUseCaseProtocol
    
    init(useCase: AttendanceUseCaseProtocol) {
        self.useCase = useCase
    }
    
    enum Action {
        case viewDidLoad
        case checkAttendanceButtonTap
    }
    
    enum Mutation {
        case setValidStatus(status: GetAttendanceResponseDTO)
        case setInvalidStatus(isInvalid: Bool)
        case setCompleteAttendanceAlert
        case setAlreadyAttendanceAlert
    }
    
    struct State {
        var point: String = ""
        var isSelected: [Bool] = []
        var isEnabledCheckAttendanceButton = false
        var showInvalid: Bool = false
        var showCompleteAlert: Bool = false
        var showAlreadyDoneAlert: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            
            return useCase.checkAttendance()
                .map { status in
                    switch status {
                    case .valid(let status):
                        return .setValidStatus(status: status)
                        
                    case .inValid:
                        return .setInvalidStatus(isInvalid: true)
                    }
                }
            
        case .checkAttendanceButtonTap:
            return useCase.fetchAttendanceResult()
                .map { status in
                    switch status {
                    case .success:
                        return .setCompleteAttendanceAlert

                    default:
                        return .setAlreadyAttendanceAlert
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setValidStatus(let status):
            var newState = state
            newState.point = "\(status.point)P"
            newState.isSelected = fetchIsSelected(status.dayStatus)
            newState.isEnabledCheckAttendanceButton = isTodayAttendance(status.dayStatus)
            return newState
            
        case .setCompleteAttendanceAlert:
            var newState = state
            newState.showCompleteAlert = true
            return newState
            
        case .setAlreadyAttendanceAlert:
            var newState = state
            newState.showAlreadyDoneAlert = true
            return newState
            
        case .setInvalidStatus(let isInvalid):
            var newState = state
            newState.showInvalid = isInvalid
            return newState
        }
    }
}

extension AttendanceReactor {
    func fetchIsSelected(_ days: [GetAttendanceResponseDTO.DayStatus]) -> [Bool] {
        return days.map { attendance in
            attendance.isAttended
        }
    }
    
    func isTodayAttendance(_ days: [GetAttendanceResponseDTO.DayStatus]) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE"
        
        let today = dateFormatter.string(from: Date()).uppercased()
        
        let todayStatus = days
            .filter { $0.day == today  }
            .map { $0.isAttended }
        
        let isEnabled = todayStatus
            .map { !$0 }.first
        
        return isEnabled ?? false
    }
}
