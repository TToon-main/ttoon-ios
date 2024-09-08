//
//  SetNickNameReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/8/24.
//

import ReactorKit
import RxSwift

enum TextFieldStatus {
    case duplication
    case valid
}

final class SetNickNameReactor: Reactor {    
    private let setNickNameUseCase: SetNickNameUseCase
    
    init(setNickNameUseCase: SetNickNameUseCase) {
        self.setNickNameUseCase = setNickNameUseCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewDidLoad
        case textFiledText(text: String)
        case confirmButtonTap(text: String)
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setFocusTextField(isFocus: Bool)
        case truncateText(text: String) 
        case isValid(status: TextFieldStatus)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var focusTextField: Bool = false
        var text: String? = nil
        var textFieldStatus: TextFieldStatus = .valid
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setFocusTextField(isFocus: true))
            
        case .textFiledText(let text):
            let truncateText = setNickNameUseCase.truncateText(text: text)
            
            return .just(.truncateText(text: truncateText))
            
        case .confirmButtonTap(let text):
            return setNickNameUseCase.isValidText(text: text)
                .map {  Mutation.isValid(status: $0) }
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
            newState.textFieldStatus = status 
            return newState
            
        case .truncateText(text: let text):
            var newState = state
            newState.text = text
            return newState
        }
    }
}
