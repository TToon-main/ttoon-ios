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
    // TODO: UseCase DI 처리하기
    private let contactUsUseCase = ContactUsUseCase(ContactUsRepository())
    
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
        case complete(Result<Bool, Error>)
        
        // 네트워크 통신 요청에 필요한 정보
        case setEmailString(String)
        case setCategoryString(String)
        case setContentString(String)
    }
    
    struct State {
        var isEmailValid: Bool = false
        var category: ContactCategory?
        var isContentValid: Bool = true
        var contentCount: Int = 0
        var buttonEnabled: Bool = false
        var completeResult: Result<Bool, Error>?
        
        // 네트워크 통신 요청에 필요한 정보
        var emailString: String = ""
        var categoryString: String = ""
        var contentString: String = ""
    }
    
    
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        // button enabled는 여러 조건을 만족해야 하기 때문에 여러곳에서 check 메서드 실행 후 concat으로 합침
        
    
        switch action {
        case .emailText(let email):
            // 아무것도 입력하지 않은 경우, 이메일 텍스트필드는 통과,
            // 완료 버튼은 비활성화 되어야 한다
            let isValid = (email.isEmpty) || isValidEmail(email)
            let isValidForCompleteButton = (!email.isEmpty) && isValidEmail(email)
            
            return .concat([
                .just(.setEmailValidity(isValid)),
                .just(.setEmailString(email)),
                .just(.enabledButton(checkButtonEnabled(
                    emailValid: isValidForCompleteButton,
                    category: currentState.category,
                    contentCount: currentState.contentCount
                )))
            ])
            
            
        case .categoryTapped(let category):
            
            return .concat([
                .just(.setCategory(category)),
                .just(.setCategoryString(category.description)),
                .just(.enabledButton(checkButtonEnabled(
                    emailValid: currentState.isEmailValid,
                    category: category,
                    contentCount: currentState.contentCount
                )))
            ])
            
            
        case .contentText(let content):
            var isValid = (content.count <= 200)
            var count = content.count
            
            // 텍스트뷰의 특성상 placeholder가 텍스트로 들어가기 때문에, 이에 대한 예외처리
            if content == "어떤 내용이 궁금하신가요?" {
                isValid = true // completeButton 활성화 여부는 count로 계산하기 때문에 이 isValid와는 관련이 없다. 단순히 텍스트뷰의 테두리 빨간색 여부만 이걸로 판단
                count = 0
            }
            
            return .concat([
                .just(.setContentValidity(isValid)),
                .just(.setContentCount(count)),
                .just(.setContentString(content)),
                .just(.enabledButton(checkButtonEnabled(
                    emailValid: currentState.isEmailValid,
                    category: currentState.category,
                    contentCount: count
                )))
            ])
            
        case .completeButtonTapped:
            // TODO:
            // 네트워크 통신
            // 얼럿 띄워주기
            
            // 1. 네트워크 통신
            let email = currentState.emailString
            let category = currentState.categoryString
            let content = currentState.contentString
            
            let requestModel = ContactUsRequestModel(
                receiver: email,
                category: category,
                body: content
            )
            
            return contactUsUseCase.contactUsRequest(requestModel)
                .asObservable()
                .map { result in
                    print("func mutate - completButton Tapped - 결과 : \(result)")
                    return .complete(result)
                }
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
            
        case .setEmailString(let email):
            newState.emailString = email
            
        case .setCategoryString(let category):
            newState.categoryString = category
            
        case .setContentString(let content):
            newState.contentString = content
            
        case .complete(let result):
            newState.completeResult = result
        }
        
        return newState
    }
}


extension ContactUsReactor {
    // 이메일 유효성 검증
    private func isValidEmail(_ text: String?) -> Bool {
        guard let text = text else { return true }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }

    // 버튼 isEnabled 조건
    private func checkButtonEnabled(emailValid: Bool, category: ContactCategory?, contentCount: Int) -> Bool {
            return emailValid && category != nil && contentCount > 0 && contentCount <= 200
        }
}
