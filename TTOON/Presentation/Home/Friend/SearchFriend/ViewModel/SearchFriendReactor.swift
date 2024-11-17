//
//  SearchFriendViewModel.swift
//  TTOON
//
//  Created by 임승섭 on 9/4/24.
//

import ReactorKit
import UIKit

class SearchFriendReactor: Reactor {
    private let searchFriendUseCase: SearchFriendUseCaseProtocol
    
    init(_ useCase: SearchFriendUseCaseProtocol) {
        self.searchFriendUseCase = useCase
    }
    
    enum Action {
        case searchUserList(String) // 맨 처음 로드
        case loadNextList   // pagination (이후 로드)
        case requestFriend(String)
    }
    
    enum Mutation {
        case setSearchText(String)
        case setUserList([SearchedUserInfoModel], Int)  // 새롭게 받은 리스트, 다음 페이지 번호
        case showAlreadyRequestedFriendBottomSheet(String)
        case pass
    }
    
    struct State {
        var searchText: String = ""
        var searchedUserList: [SearchedUserInfoModel] = []
        var page: Int = 0   // "다음"에 요청할 페이지 번호
        
        // 이미 요청을 받은 유저에 대한 처리
        var alreadyRequestedUserNickname = ""   // 닉네임 값 바뀌면 바텀시트 띄우는 로직 (빈 문자열일 때는 x)
    }
    
    let initialState = State()
    private var disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchUserList(let searchText):
            // 서치바로 검색한 경우는 무조건 page = 0
//            let curPage = currentState.page
            let curPage = 0
            
            
            return .concat([
                // searchText 저장
                .just(.setSearchText(searchText)),
                
                // 네트워크 통신
                searchFriendUseCase.searchUserList(
                    UserListRequestModel(searchStr: searchText, page: curPage)
                )
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let newList):
                        print("search User List : \(newList)")
                        return .setUserList(newList, 1)
                        
                    case .failure(let error):
                        print("search User List Error : \(error)")
                        return .pass
                    }
                }
            ])
            
            
        case .loadNextList:
            let currentPage = currentState.page
            let searchText = currentState.searchText
            
            return searchFriendUseCase.searchUserList(UserListRequestModel(searchStr: searchText, page: currentPage))
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let arr):
                        let newList = self.currentState.searchedUserList + arr
                        return .setUserList(newList, currentPage + 1)
                        
                    case .failure(let error):
                        return .pass
                    }
                }
            
            
        case .requestFriend(let nickname):
            
            return searchFriendUseCase.requestFriend(nickname)
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let value):
                        // 1. 요청 성공
                        if value == .success {
                            print("request success")
                            
                            // 배열 업데이트
                            // 배열에서 해당 닉네임을 가진 유저의 상태값을 "요청됨"으로 바꿔준다.
                            let newList = self.currentState.searchedUserList.map {
                                if $0.userInfo.nickname == nickname {
                                    var updatedUser = $0
                                    updatedUser.status = .waiting
                                    return updatedUser
                                } else {
                                    return $0
                                } 
                            }
                            
                            // 페이지
                            let curPage = self.currentState.page
                            
                            return .setUserList(newList, curPage)
                        }
                        
                        // 2. 이미 상대방이 요청함
                        else if value == .alreadyReceivedRequest {
                            // 바텀시트 보여줘야 함
                            // \(nickname)님에게 친구 신청을 받은 상태에요
                            return .showAlreadyRequestedFriendBottomSheet(nickname)
                        }
                        
                        else {
                            print("request fail")
                            return .pass
                        }
                        
                    case .failure(let error):
                        print("Error!! \(error)")
                        return .pass
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSearchText(let searchText):
            newState.searchText = searchText
            
        case .setUserList(let searchedUserList, let newPage):
            newState.searchedUserList = searchedUserList
            newState.page = newPage
            
        case .showAlreadyRequestedFriendBottomSheet(let nickname):
            newState.alreadyRequestedUserNickname = nickname
    
        case .pass:
            print("Error. pass case")
        }
        
        return newState
    }
}
