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
        case nickName(String)
        case changeImageButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setUpProfile(SetProfileResponseModel)
        case setTruncateNickName(String)
        case setChangeImage
        case setSaveButtonEnabled(Bool)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var profileInfo: SetProfileResponseModel? = .none
        var truncatedText: String? = .none
        var errorMessage: String? = .none
        var presentImagePicker: Void? = .none 
        var isSaveButtonEnabled: Bool = false
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
            
        case .nickName(let text):
            let truncatedText = truncateText(text: text)
            
            let nickNameChanged = truncatedText != currentState.profileInfo?.nickName 
            let notEmpty = !truncatedText.isEmpty
            let isSaveEnabled = notEmpty && nickNameChanged
            
            return Observable.concat([
                .just(.setTruncateNickName(truncatedText)),
                .just(.setSaveButtonEnabled(isSaveEnabled))
            ])
            
        case .changeImageButtonTap:
            return .just(.setChangeImage)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUpProfile(let model):
            newState.profileInfo = model
            newState.presentImagePicker = nil
            
        case .setTruncateNickName(let nickName):
            newState.truncatedText = nickName
            newState.errorMessage = self.isDuplicateNickName(text: nickName)
            newState.presentImagePicker = nil
            
        case .setChangeImage:
            newState.presentImagePicker = ()
            
        case .setSaveButtonEnabled(let isEnabled):
            newState.isSaveButtonEnabled = isEnabled
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
    
    func isDuplicateNickName(text: String) -> String? {
        if text == "에러" {
            return "중복된 메세지 입니다."
        } else {
            return nil
        }
    }
}
