//
//  FriendListReactor.swift
//  TTOON
//
//  Created by 임승섭 on 8/17/24.
//

import Foundation
import ReactorKit
import RxSwift

// 1. loadData
    // - 빈 배열일 때 noDataView hidden 풀어주기
    // page = 0으로 초기 데이터 로드
// 2. pagination
    // - page값 +1 해서 네트워크 콜
// 3. deleteFriend
    // - 네트워크 콜 하고 성공 시 배열에서 해당 원소 제거 (네트워크 콜 x). (pagination 된 상황 고려)

class FriendListReactor: Reactor {
    private let friendListUseCase: FriendListUseCaseProtocol
    
    init(_ useCase: FriendListUseCaseProtocol) {
        self.friendListUseCase = useCase
    }
    
    enum Action {
        case loadInitialFriendList  // 맨 처음 로드 (page = 0)
        case loadNextFriendList     // 이후 로드 (page > 0)
        case deleteFriend(Int)
    }
    
    enum Mutation {
        case setPage(Int)
        case setFriendList([UserInfoModel])
        case pass
    }
    
    struct State {
        var friendList: [UserInfoModel] = [] // 현재 친구들 배열
        var page: Int = 0   // "다음"에 요청할 페이지 번호
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadInitialFriendList:
            return .concat([
                // 네트워크 통신
                friendListUseCase.requestFriendList(0)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let newList):
                            return .setFriendList(newList)

                        case .failure(let error):
                            return .pass
                        }
                    },
                // page 번호 1로 올려줌
                .just(.setPage(1))
            ])
            
        case .loadNextFriendList:
            let currentPage = currentState.page
            
            return .concat([
                // 네트워크 통신
                friendListUseCase.requestFriendList(currentPage)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let arr):
                            let newList = self.currentState.friendList + arr
                            return .setFriendList(newList)

                        case .failure(let error):
                            return .pass
                        }
                    },
                // page 번호 1로 올려줌
                .just(.setPage(currentPage + 1))
            ])
            
            
        case .deleteFriend(let id):
            // 친구 삭제 -> 네트워크 콜 & 배열에서 삭제
            
            // 네트워크 통신
            return friendListUseCase.deleteFriend(id)
                .asObservable()
                .map { result in
                    print("delete friend : \(result)")
                    
                    switch result {
                    case .success(let result):
                        if result {
                            // 배열에서 삭제
                            let newList = self.currentState.friendList.filter { $0.friendId != id }
                            return Mutation.setFriendList(newList)
                        } else {
                            return Mutation.pass
                        }

                    case .failure(let error):
                        print("error : \(error)")
                        return .pass
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setFriendList(let newArr):
            newState.friendList = newArr

        case .setPage(let newPage):
            newState.page = newPage
            
        case .pass:
            print("pass")
        }
        
        return newState
    }
}
