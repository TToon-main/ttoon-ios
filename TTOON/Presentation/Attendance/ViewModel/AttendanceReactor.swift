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
        case refreshAttendance
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
        case .viewDidLoad, .refreshAttendance:
            
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
        var newState = fetchNewState(state: state)
        
        switch mutation {
        case .setValidStatus(let status):
            newState.point = "\(status.point)P"
            newState.isSelected = fetchIsSelected(status.dayStatus)
            newState.isEnabledCheckAttendanceButton = isTodayAttendance(status.dayStatus)
            return newState
            
        case .setCompleteAttendanceAlert:
            newState.showCompleteAlert = true
            return newState
            
        case .setAlreadyAttendanceAlert:
            newState.showAlreadyDoneAlert = true
            return newState
            
        case .setInvalidStatus(let isInvalid):
            newState.showInvalid = isInvalid
            return newState
        }
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
         
        new.showCompleteAlert = false
        new.showAlreadyDoneAlert = false
         
        return new
      }
}

extension AttendanceReactor {
    func fetchIsSelected(_ days: [GetAttendanceResponseDTO.DayStatus]) -> [Bool] {
        return days.map { attendance in
            attendance.isAttended
        }
    }
    
    func isTodayAttendance(_ days: [GetAttendanceResponseDTO.DayStatus]) -> Bool {
        let today = Date().toString(of: .onlyDay).uppercased()
        
        let todayStatus = days
            .filter { $0.day == today  }
            .map { $0.isAttended }
        
        let isEnabled = todayStatus
            .map { !$0 }.first
            
        return isEnabled ?? false
    }
}
