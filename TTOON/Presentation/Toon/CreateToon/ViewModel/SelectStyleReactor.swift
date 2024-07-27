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
        case modelSelected
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setIsEnabledConfirmButton(Bool)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var isEnabledConfirmButton: Bool = false
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .modelSelected:
            return .just(.setIsEnabledConfirmButton(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsEnabledConfirmButton(let isEnabled):
            newState.isEnabledConfirmButton = isEnabled
        }
        return newState
    }
}
