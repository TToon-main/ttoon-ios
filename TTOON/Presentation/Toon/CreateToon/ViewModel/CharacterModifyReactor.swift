//
//  CharacterModifyReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import ReactorKit
import RxSwift

final class CharacterModifyReactor: Reactor {    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case deletedCharacterTap(String?)
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setDeletedCharacterTap(String?)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var presentCharacterDeleteBS: String? = nil
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .deletedCharacterTap(let name):
            return .just(.setDeletedCharacterTap(name))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDeletedCharacterTap(let name):
            newState.presentCharacterDeleteBS = name
        }
        
        return newState
    }
}
