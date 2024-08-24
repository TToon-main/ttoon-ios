//
//  FriendListReactor.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import Foundation
import ReactorKit
import RxSwift

class FriendListReactor: Reactor {
    init() { }
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
    }
}
