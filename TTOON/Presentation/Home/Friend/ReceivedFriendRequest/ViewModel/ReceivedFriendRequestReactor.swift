//
//  ReceivedFriendRequestReactor.swift
//  TTOON
//
//  Created by 임승섭 on 9/2/24.
//

import Foundation
import ReactorKit
import RxSwift

class ReceivedFriendRequestReactor: Reactor {
    init() { }
    
    enum Action {
        case loadReceivedRequestList
        case acceptRequest(Int)
        case rejectRequest(Int)
    }
    
    enum Mutation {
        case setReceivedRequestList([UserInfo])
        case sample(Int)
    }
    
    struct State {
        var receivedRequestList: [UserInfo] = []
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadReceivedRequestList:
            var friendList: [UserInfo] = []
            for i in 0...100 { friendList.append(UserInfo(id: i)) }
            return .just(.setReceivedRequestList(friendList))
             
        case .acceptRequest(let id):
                            
            return .just(.sample(id))

        case .rejectRequest(let id):
            return .just(.sample(id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setReceivedRequestList(let requestList):
            newState.receivedRequestList = requestList

        case .sample(let id):
            print("sample : ", id)
        }
        
        return newState
    }
}
