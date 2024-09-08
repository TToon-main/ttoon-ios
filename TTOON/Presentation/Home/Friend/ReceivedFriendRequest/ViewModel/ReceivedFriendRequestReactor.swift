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
    private let receivedFriendRequestUseCase: ReceivedFriendRequestUseCase
    
    init(_ useCase: ReceivedFriendRequestUseCase) {
        self.receivedFriendRequestUseCase = useCase
    }
    
    enum Action {
        case loadReceivedRequestList
        case acceptRequest(Int)
        case rejectRequest(Int)
    }
    
    enum Mutation {
        case setReceivedRequestList(Result<[UserInfoModel], Error>)
        case sample(Int)
    }
    
    struct State {
        var receivedRequestList: [UserInfoModel] = []
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadReceivedRequestList:
            
            // 네트워크 통신
            return receivedFriendRequestUseCase.receivedRequestList(0)
                .asObservable()
                .map { result in
                    print("load received list : \(result)")
                    return .setReceivedRequestList(result)
                }
            
        
             
        case .acceptRequest(let id):
                            
            return .just(.sample(id))

        case .rejectRequest(let id):
            return .just(.sample(id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setReceivedRequestList(let result):
            switch result {
            case .success(let requestList):
                newState.receivedRequestList = requestList
                
            case .failure(let error):
                print("ERror: \(error)")
            }
            
            

        case .sample(let id):
            print("sample : ", id)
        }
        
        return newState
    }
}
