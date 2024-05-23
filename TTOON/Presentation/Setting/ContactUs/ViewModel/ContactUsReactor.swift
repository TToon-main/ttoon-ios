//
//  ContactUsReactor.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import Foundation
import ReactorKit
import RxSwift

// TODO: Button Enabled output으로 전달해야 함

class ContactUsReactor: Reactor {
    init() {
    }
    
    enum Action {
        case emailText(String)
        case categoryTapped(ContactCategory)
        case contentText(String)
        case completeButtonTapped
    }
    
    enum Mutation {
        case setEmailValidity(Bool)
        case setCategory(ContactCategory)
        case setContentValidity(Bool)
        case setContentCount(Int)
        case enabledButton(Bool)
        case complete(Bool)
    }
    
    struct State {
        var isEmailValid: Bool = false
        var category: ContactCategory?
        var isContentValid: Bool = true
        var contentCount: Int = 0
        var buttonEnabled: Bool = false
        var completeResult: Result<Bool, Error>?
    }
    
    
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    
    
    func mutate(action: Action) -> Observable<Mutation> {
//        // 여러 액션을 동시에 적용해야 함.
//        let buttonEnabled = (currentState.isEmailValid) && (currentState.category != nil) && (currentState.contentCount <= 200) && (currentState.contentCount > 0)
//        let buttonEnabledMutation = Observable.just(Mutation.enabledButton(buttonEnabled))
        
        
        
        switch action {
        case .emailText(let email):
            let isValid = (email.isEmpty) || isValidEmail(email)
            return .just(.setEmailValidity(isValid))
//                .concat(buttonEnabledMutation)
            
        case .categoryTapped(let category):
            return .just(.setCategory(category))
//                .concat(buttonEnabledMutation)
            
        case .contentText(let content):
            let isValid = (content.count <= 200)
            let count = content.count
//            let buttonEnabled =
//            (currentState.isEmailValid) && currentState.category != nil && count <= 200 && !content.isEmpty
            return Observable.just(.setContentValidity(isValid))
                .concat(Observable.just(.setContentCount(count)))
//                .concat(buttonEnabledMutation)
//                .concat(Observable.just(.enabledButton(buttonEnabled)))
            
        case .completeButtonTapped:
            return .just(.complete(true))
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setEmailValidity(let validEmail):
            newState.isEmailValid = validEmail
            
        case .setCategory(let category):
            newState.category = category
            
        case .setContentValidity(let contentValid):
            newState.isContentValid = contentValid
            
        case .setContentCount(let contentCount):
            newState.contentCount = contentCount
            
        case .enabledButton(let value):
            newState.buttonEnabled = value
            
        case .complete:
            newState.completeResult = .success(true)
        }
        
        return newState
    }
}


extension ContactUsReactor {
    // 이메일 유효성 검증
    private func isValidEmail(_ text: String?) -> Bool {
        guard let text = text else { return true }
//        if text.isEmpty { return true }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
}
