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
        case loadFriendList
        case deleteFriend(Int)
    }
    
    enum Mutation {
        case setFriendList([UserInfo])
        case deleteFriend(Int)
    }
    
    struct State {
        var friendList: [UserInfo] = [] // 현재 친구들 배열
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadFriendList:
            var friendList: [UserInfo] = []
            for i in 0...100 { friendList.append(UserInfo(id: i)) }
            
            return .just(.setFriendList(friendList))
            
        case .deleteFriend(let id):
            return .just(.deleteFriend(id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setFriendList(let friendList):
            newState.friendList = friendList

        case .deleteFriend(let int):
            print("delete : ", int)
        }
        
        return newState
    }
}


struct UserInfo {
    let id: Int
}
