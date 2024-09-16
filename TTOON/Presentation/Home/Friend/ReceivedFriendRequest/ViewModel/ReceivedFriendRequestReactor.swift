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
    
    var reloadFriendListCallBack: (() -> Void)? // '요청 수락'을 하게 되면, "친구 목록" 탭 데이터 reload
    
    init(_ useCase: ReceivedFriendRequestUseCase) {
        self.receivedFriendRequestUseCase = useCase
    }
    
    enum Action {
        case loadReceivedRequestList
        case loadNextList
        case acceptRequest(Int) // friend id
        case rejectRequest(Int) // friend id
    }
    
    enum Mutation {
        case setReceivedRequestList([UserInfoModel], Int)   // 새로운 리스트, 다음 페이지 번호
        case pass
    }
    
    struct State {
        var receivedRequestList: [UserInfoModel] = []
        var page: Int = 0
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
                    switch result {
                    case .success(let newList):
                        print("received Request List : \(newList)")
                        return .setReceivedRequestList(newList, 1)
                        
                    case .failure(let error):
                        print("Error : \(error)")
                        return .pass
                    }
                }
            
        case .loadNextList:
            return .just(.pass)
            
            
             
        case .acceptRequest(let id):
            // 네트워크 통신
            return receivedFriendRequestUseCase.acceptFriendRequest(id)
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let value):
                        if value {
                            print("accpet success")
                            // 배열 업데이트
                            let newList = self.currentState.receivedRequestList.filter { $0.friendId != id }
                            
                            // 페이지
                            let curPage = self.currentState.page
                            
                            self.reloadFriendListCallBack?()  // 친구 목록 탭 리스트 업데이트
                            return .setReceivedRequestList(newList, curPage)
                        } else {
                            return .pass
                        }
                        
                    case .failure(let error):
                        print("Error : :\(error)")
                        return .pass
                    }
                }
                            
        case .rejectRequest(let id):
            // 네트워크 통신
            return receivedFriendRequestUseCase.rejectFriendRequest(id)
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let value):
                        if value {
                            print("reject success")
                            // 배열 업데이트
                            let newList = self.currentState.receivedRequestList.filter { $0.friendId != id }
                            
                            // 페이지
                            let curPage = self.currentState.page
                            
                            return .setReceivedRequestList(newList, curPage)
                        } else {
                            return .pass
                        }
                        
                    case .failure(let error):
                        print("Error : :\(error)")
                        return .pass
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setReceivedRequestList(let requestList, let page):
            newState.receivedRequestList = requestList
            newState.page = page

        case .pass:
            print("pass")
        }
        
        return newState
    }
}


extension ReceivedFriendRequestReactor {
    // 친구 수락 or 거절 시 배열에서 id 찾아서 제거 후 리턴
    private func removeRequestFromArr(_ id: Int, arr: [UserInfoModel]) -> [UserInfoModel] {
        return arr.filter { $0.friendId != id }
    }
}
