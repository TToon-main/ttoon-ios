//
//  LikeUserListReactor.swift
//  TTOON
//
//  Created by 임승섭 on 10/28/24.
//

import Foundation
import ReactorKit
import RxSwift

class LikeUserListReactor: Reactor {
    private let likeUserListUseCase: LikeUserListUseCaseProtocol
    
    init(_ useCase: LikeUserListUseCaseProtocol, feedId: Int) {
        self.likeUserListUseCase = useCase
        self.initialState = State(feedId: feedId)
    }
    
    enum Action {
        case loadData
    }
    
    enum Mutation {
        case setLikeUserList([UserInfoModel])
        case pass
    }
    
    struct State {
        let feedId: Int
        var likeUserList: [UserInfoModel] = []
    }
    
    let initialState: State
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            let feedId = currentState.feedId
            return likeUserListUseCase.getLikeUserList(feedId)
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let list):
                        print(list)
                        return .setLikeUserList(list)
                        
                    case .failure:
                        print("eeeeeerror")
                        return .pass
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setLikeUserList(let list):
            newState.likeUserList = list

        case .pass:
            print("pass")
        }
        
        return newState
    }
}
