//
//  SearchFriendViewModel.swift
//  TTOON
//
//  Created by 임승섭 on 9/4/24.
//

import ReactorKit
import UIKit

class SearchFriendReactor: Reactor {
    init() { }
    
    enum Action {
        case searchUserList(String)
    }
    
    enum Mutation {
        case searchUserList([UserInfo])
    }
    
    struct State {
        var searchedUserList: [UserInfo] = []
    }
    
    let initialState = State()
    private var disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchUserList(let string):
            var list: [UserInfo] = []
            for i in 0...100 { list.append(UserInfo(id: i))}
            return .just(.searchUserList(list))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .searchUserList(let searchedUserList):
            newState.searchedUserList = searchedUserList
        }
        
        return newState
    }
}
