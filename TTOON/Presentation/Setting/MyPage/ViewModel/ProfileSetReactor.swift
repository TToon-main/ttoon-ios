//
//  ProfileSetReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import ReactorKit
import RxSwift
import UIKit

final class ProfileSetReactor: Reactor {
    let useCase: MyPageUseCase
    
    init(useCase: MyPageUseCase) {
        self.useCase = useCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewWillAppear
        case copyButtonTap(String)
        case truncateNickName(String)
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setUpProfile(SetProfileResponseModel)
        case setTruncateNickName(String)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var profileInfo: SetProfileResponseModel? = .none
        var truncatedText: String? = .none
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear: 
            return userInfo().map { Mutation.setUpProfile($0)}
            
        case  .copyButtonTap(let email): 
            copyEmail(email: email)
            return .never()
            
        case .truncateNickName(let nickName):
            let truncatedText = truncateText(text: nickName)
            return .just(.setTruncateNickName(truncatedText)) 
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUpProfile(let model):
            newState.profileInfo = model

        case .setTruncateNickName(let nickName):
            newState.truncatedText = nickName
        }
        
        return newState
    }
}

extension ProfileSetReactor {
    func userInfo() -> Observable<SetProfileResponseModel>  {
        return useCase.getProfileInfo()
            .map { $0.element }
            .compactMap { $0 }
    }
    
    func copyEmail(email: String) {
        useCase.copyToClipboard(text: email)
    }
    
    func truncateText(text: String) -> String {
        return useCase.truncateText(text)
    }
}
