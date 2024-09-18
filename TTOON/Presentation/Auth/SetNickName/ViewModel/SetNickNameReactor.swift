//
//  SetNickNameReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import ReactorKit
import RxSwift



final class SetNickNameReactor: Reactor {
    private let setNickNameUseCase: SetNickNameUseCaseProtocol
    
    init(setNickNameUseCase: SetNickNameUseCaseProtocol) {
        self.setNickNameUseCase = setNickNameUseCase
    }
    
    enum Action {
        case viewDidLoad
        case popButtonTap
        case textFiledText(text: String)
        case confirmButtonTap(text: String)
    }
    
    enum Mutation {
        case setDismiss
        case isEnabledConfirmButton(isEnabled: Bool)
        case setFocusTextField(isFocus: Bool)
        case truncateText(text: String)
        case isValid(status: SetNickNameUseCase.TextFieldStatus)
    }
    
    struct State {
        var dismiss: Bool = false
        var toTabBar: Bool = false
        var isEnabledConfirmButton: Bool = false
        var focusTextField: Bool = false
        var text: String? = nil
        var setErrorMessage: String? = nil
    }

    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setFocusTextField(isFocus: true))
            
        case .textFiledText(let text):
            let truncateText = setNickNameUseCase.truncateText(text: text)
            
            let isEnabled = !text.isEmpty
            
            return .concat([
                .just(.truncateText(text: truncateText)),
                .just(.isEnabledConfirmButton(isEnabled: isEnabled)),
                .just(.isValid(status: .ready))
            ])
            
        case .confirmButtonTap(let text):
            let dto = PostIsValidNickNameRequestDTO(nickName: text)
            
            return setNickNameUseCase.isValidText(dto: dto)
                .map {  Mutation.isValid(status: $0) }
            
        case .popButtonTap:
            return .just(.setDismiss)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setFocusTextField(let isFocus):
            var newState = state
            newState.focusTextField = isFocus
            return newState
            
        case .isValid(let status):
            var newState = state
            
            switch status {
            case .duplication:
                newState.setErrorMessage = "이미 사용 중인 닉네임입니다."
                newState.isEnabledConfirmButton = false
                
            case .unknown:
                newState.setErrorMessage = "알 수 없는 에러입니다."
                newState.isEnabledConfirmButton = false
                
            case .valid:
                newState.toTabBar = true
                
            default:
                newState.setErrorMessage = nil
            }
            
            return newState
            
        case .truncateText(let text):
            var newState = state
            newState.text = text
            return newState
            
        case .isEnabledConfirmButton(let isEnabled):
            var newState = state
            newState.isEnabledConfirmButton = isEnabled
            return newState
            
        case .setDismiss:
            var newState = state
            newState.dismiss = true
            return newState
        }
    }
}
