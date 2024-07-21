//
//  EnterInfoReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import ReactorKit
import RxSwift

final class EnterInfoReactor: Reactor {    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case textFieldDidChange(String)
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setTextFieldText(String?)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var validTextFieldText: String? = nil
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textFieldDidChange(let text):
            let validText = truncText(text: text)
            return .just(.setTextFieldText(validText))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTextFieldText(let text):
            newState.validTextFieldText = text
        }
        
        return newState
    }
    
    private func truncText(text: String) -> String? {
        let maxLength = 200
        return String(text.prefix(maxLength))
    }
}
