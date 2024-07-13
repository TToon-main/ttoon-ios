//
//  SelectStyleReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import ReactorKit
import RxSwift

final class SelectStyleReactor: Reactor {    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewWillAppear
        case modelSelected
        case confirmButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setRefreshAction
        case setIsEnabledConfirmButton(Bool)
        case setPresentEnterInfoVC
    }
    
    // 뷰에 전달할 상태
    struct State {
        var refreshDate: Void = ()
        var isEnabledConfirmButton: Bool = false
        var presentEnterInfoVC: Void? = nil
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .just(.setRefreshAction)
            
        case .modelSelected:
            return .just(.setIsEnabledConfirmButton(true))

        case .confirmButtonTap:
            return .just(.setPresentEnterInfoVC)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRefreshAction:
            newState.presentEnterInfoVC = nil
            
        case .setIsEnabledConfirmButton(let isEnabled):
            newState.isEnabledConfirmButton = isEnabled

        case .setPresentEnterInfoVC:
            newState.presentEnterInfoVC = ()
        }
        
        return newState
    }
}
