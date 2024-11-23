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
        case loadReceivedRequestList    // 맨 처음 로드
        case loadNextList               // 이후 로드
        case acceptRequest(Int) // friend id
        case rejectRequest(Int) // friend id
    }
    
    enum Mutation {
        case setReceivedRequestList([UserInfoModel], Int)   // 새로운 리스트, 다음 페이지 번호
        case setResult(type: FriendToastView.Status, nickname: String)
        case pass
    }
    
    struct State {
        var receivedRequestList: [UserInfoModel] = []
        var page: Int = 0
        
        var result: ReceivedFriendRequestReactor.Result = .init(type: .accept, nickname: "")
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
            let currentPage = currentState.page
            
            return receivedFriendRequestUseCase.receivedRequestList(currentPage)
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let arr):
                        let newList = self.currentState.receivedRequestList + arr
                        return .setReceivedRequestList(newList, currentPage + 1)
                        
                    case .failure(let error):
                        return .pass
                    }
                }
            
            
             
        case .acceptRequest(let id):
            // 네트워크 통신
            return receivedFriendRequestUseCase.acceptFriendRequest(id)
                .asObservable()
                .flatMap { [self] result in
                    switch result {
                    case .success(let value):
                        if value {
                            print("accpet success")
                            // 수락한 유저 닉네임
                            let nickname = getNicknameFromArr(id, arr: self.currentState.receivedRequestList)
                            
                            // 배열 업데이트
                            let newList = self.currentState.receivedRequestList.filter { $0.friendId != id }
                            
                            // 페이지
                            let curPage = self.currentState.page
                            
                            // 친구 목록 탭 리스트 업데이트
                            self.reloadFriendListCallBack?()
                            
                            return Observable.concat([
                                Observable.just(.setReceivedRequestList(newList, curPage)),
                                Observable.just(Mutation.setResult(type: .accept, nickname: nickname))
                            ])
                        } else {
                            return .just(.pass)
                        }
                        
                    case .failure(let error):
                        print("Error : :\(error)")
                        return .just(.pass)
                    }
                }
                            
        case .rejectRequest(let id):
            // 네트워크 통신
            return receivedFriendRequestUseCase.rejectFriendRequest(id)
                .asObservable()
                .flatMap { [self] result in
                    switch result {
                    case .success(let value):
                        if value {
                            print("reject success")
                            // 거절한 유저 닉네임
                            let nickname = getNicknameFromArr(id, arr: self.currentState.receivedRequestList)
                            
                            // 배열 업데이트
                            let newList = self.currentState.receivedRequestList.filter { $0.friendId != id }
                            
                            // 페이지
                            let curPage = self.currentState.page
                            
                            
                            return Observable.concat([
                                Observable.just(Mutation.setReceivedRequestList(newList, curPage)),
                                Observable.just(Mutation.setResult(type: .reject, nickname: nickname))
                            ])
                        } else {
                            return .just(Mutation.pass)
                        }
                        
                    case .failure(let error):
                        print("Error : :\(error)")
                        return .just(Mutation.pass)
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
            
        case .setResult(let type, let nickname):
            newState.result = Result(type: type, nickname: nickname)
        
            
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
    
    // id가지고 배열에서 해당 유저의 닉네임 리턴
    private func getNicknameFromArr(_ id: Int, arr: [UserInfoModel]) -> String {
        return arr.first { $0.friendId == id }?.nickname ?? ""
    }
}


extension ReceivedFriendRequestReactor {
    struct Result: Equatable {
        let type: FriendToastView.Status
        let nickname: String
    }
}
