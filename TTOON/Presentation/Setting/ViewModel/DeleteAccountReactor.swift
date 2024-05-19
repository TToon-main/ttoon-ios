//
//  DeleteAccountReactor.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import Foundation
import ReactorKit
import RxSwift

// TODO: "완료"에 대해 구현 필요
// TODO: TextView count placeholder 예외처리
// TODO: 버튼 활성화 조건

class DeleteAccountReactor: Reactor {
    init() { }
    
    enum Action {
        case deleteReason(DeleteAccountReason)
        case directInputText(String)
        case completeButtonTapped
    }
    
    enum Mutation {
        case setReason(DeleteAccountReason)
        case showTextView(Bool)
        case setDirectInputTextValidity(Bool)
        case setDirectInputTextCount(Int)
        case enabledButton(Bool)
        case complete(Bool)
    }
    
    struct State {
        var deleteReason: DeleteAccountReason?
        var showTextView: Bool = false
        var directInputTextValid: Bool = true
        var directInputTextCount: Int = 0
        var buttonEnabled: Bool = false
        var completeResult: Result<Bool, Error>?
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .deleteReason(let deleteAccountReason):
            let showTextView = (deleteAccountReason == .directInput)
            let buttonEnabled = deleteAccountReason != .directInput
            
            return Observable.just(.setReason(deleteAccountReason))
                .concat(Observable.just(.showTextView(showTextView)))
                .concat(Observable.just(.enabledButton(buttonEnabled)))
            
        case .directInputText(let inputText):
            let isValid = inputText.count <= 100
            let count = inputText.count
            let buttonEnabled = currentState.deleteReason == .directInput && count <= 100 && !inputText.isEmpty
            
            return Observable.just(.setDirectInputTextCount(count))
                .concat(Observable.just(.setDirectInputTextValidity(isValid)))
                .concat(Observable.just(.enabledButton(buttonEnabled)))
                
            
        case .completeButtonTapped:
            return .just(.complete(true))
        }
    }
    
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setReason(let deleteAccountReason):
            newState.deleteReason = deleteAccountReason
            
        case .showTextView(let showTextView):
            newState.showTextView = showTextView
            
        case .setDirectInputTextValidity(let value):
            newState.directInputTextValid = value
            
        case .setDirectInputTextCount(let cnt):
            newState.directInputTextCount = cnt
            
        case .enabledButton(let bool):
            newState.buttonEnabled = bool
            
        case .complete:
            newState.completeResult = .success(true)
        }
        
        return newState
    }
}
