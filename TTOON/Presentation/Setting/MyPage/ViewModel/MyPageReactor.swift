//
//  MyPageReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/19/24.
//


import ReactorKit
import RxSwift

final class MyPageReactor: Reactor {    
    let useCase: MyPageUseCase
    
    init(useCase: MyPageUseCase) {
        self.useCase = useCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewWillAppear
        case profileSettingButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setUpUserInfo(UserInfoResponseModel)
        case setPresentProfileSetVC
    }
    
    // 뷰에 전달할 상태
    struct State {
        var userInfo: UserInfoResponseModel? = .none
        var presentProfileSetVC: Void? = .none
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return userInfo()
                .map { Mutation.setUpUserInfo($0) } 

        case .profileSettingButtonTap:
            return .just(.setPresentProfileSetVC)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = State()
        
        switch mutation {
        case .setUpUserInfo(let userInfoResponseModel):
            newState.userInfo = userInfoResponseModel
            newState.presentProfileSetVC = nil
            
        case .setPresentProfileSetVC:
            newState.presentProfileSetVC = ()
        }
        
        return newState
    }
}

extension MyPageReactor {
    func userInfo() -> Observable<UserInfoResponseModel>  {
        return useCase.getUserInfo()
            .map { $0.element }
            .compactMap { $0 }
    }
}
