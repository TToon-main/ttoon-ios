//
//  ContactUsReactor.swift
//  TTOON
//
//  Created by 임승섭 on 5/19/24.
//

import Foundation
import ReactorKit
import RxSwift

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
        case complete(Bool)
    }
    
    struct State {
        var isEmailValid: Bool = true
        var category: ContactCategory?
        var isContentValid: Bool = true
        var contentCount: Int = 0
        var completeResult: Result<Bool, Error>?
    }
    
    
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .emailText(let email):
            let isValid = isValidEmail(email)
            return .just(.setEmailValidity(isValid))
            
        case .categoryTapped(let category):
            return .just(.setCategory(category))
            
        case .contentText(let content):
            let isValid = (content.count <= 200)
            let count = content.count
            return Observable.just(.setContentValidity(isValid))
                .concat(Observable.just(.setContentCount(count)))
            
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
        if text.isEmpty { return true }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
}
