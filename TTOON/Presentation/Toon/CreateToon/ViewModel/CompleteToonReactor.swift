//
//  CompleteToonReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//

import Foundation

import ReactorKit

final class CompleteToonReactor: Reactor {    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
    }
    
    // Action과 State의 매개체
    enum Mutation {
    }
    
    // 뷰에 전달할 상태
    struct State {
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
    }
}
