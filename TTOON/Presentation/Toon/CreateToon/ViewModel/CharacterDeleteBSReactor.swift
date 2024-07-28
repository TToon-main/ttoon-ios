//
//  CharacterDeleteBSReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import ReactorKit
import RxSwift

final class CharacterDeleteBSReactor: Reactor {    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case backButtonTap
        case deleteButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setDismiss
    }
    
    // 뷰에 전달할 상태
    struct State {
        var dismiss: Void? = nil
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTap:
            return .just(.setDismiss)

        case .deleteButtonTap:
            // TODO: api 요청
            return .just(.setDismiss)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setDismiss:
            newState.dismiss = ()
        }
        
        return newState
    }
}
