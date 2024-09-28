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
    }
    
    enum Mutation {
        case setValidStatus(status: GetAttendanceResponseDTO)
        case setInvalidStatus(isInvalid: Bool)
    }
    
    struct State {
        var point: String = ""
        var isSelected: [Bool] = []
        var showInvalid: Bool = false
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setValidStatus(let status):
            var newState = state
            newState.point = "\(status.point)P"
            newState.isSelected = fetchIsSelected(status: status.dayStatus)
            return newState
        case .setInvalidStatus(let isInvalid):
            var newState = state
            newState.showInvalid = isInvalid
            return newState
        }
    }
}

extension AttendanceReactor {    
    func fetchIsSelected(status: [GetAttendanceResponseDTO.DayStatus]) -> [Bool] {
        return status.map { attendance in
            attendance.isAttended
        }
    }
    
    func isToday(_ day: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" 
        return dateFormatter.string(from: Date()) == day
    }
}
