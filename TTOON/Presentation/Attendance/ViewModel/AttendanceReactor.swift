//
//  AttendanceReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/21/24.
//

import ReactorKit
import RxSwift

final class AttendanceReactor: Reactor {    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
    }
}
