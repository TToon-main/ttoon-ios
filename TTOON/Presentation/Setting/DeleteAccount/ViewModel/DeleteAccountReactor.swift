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

class DeleteAccountReactor: Reactor {
    // TODO: UseCase DI 처리하기
    private let deleteAccountUseCase = DeleteAccountUseCase(DeleteAccountRepository())
    
    init() { }
    
    enum Action {
        case deleteReason(DeleteAccountReason)
        case directInputText(String)
//        case completeButtonTapped // 이건 받을 필요 없다.
        case confirmButtonTapped    // 얼럿의 버튼을 탭한 경우만 받는다.
    }
    
    enum Mutation {
        case setReason(DeleteAccountReason)
        case showTextView(Bool)
        case setDirectInputText(String)
        case setDirectInputTextValidity(Bool)
        case setDirectInputTextCount(Int)
        case enabledButton(Bool)
        case complete(Result<Bool, Error>)
        
        // 네트워크 통신 요청에 필요한 정보 : 탈퇴 이유
        // 직접 입력 : "(직접 입력) : ~~~~"
        // 그 외 : "생성되는 이미지가 마음에 들지 않아서"
        case setReasonString(String)
    }
    
    struct State {
        var deleteReason: DeleteAccountReason?
        var showTextView: Bool = false
        var directInputText: String = "" // 일단 쓰자. 필요하다.
        var directInputTextValid: Bool = true
        var directInputTextCount: Int = 0
        var buttonEnabled: Bool = false
        var completeResult: Result<Bool, Error>?
        
        
        // 네트워크 통신 요청에 필요한 정보
        var reasonString: String = ""
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .deleteReason(let deleteAccountReason):
            // 직접 임력인 경우만 텍스트뷰 보여주기
            let showTextView = (deleteAccountReason == .directInput)
            
            
            return .concat([
                .just(.setReason(deleteAccountReason)),
                .just(.showTextView(showTextView)),
                .just(.enabledButton(checkButtonEnabled(
                    reason: deleteAccountReason,
                    directInputText: currentState.directInputText
                ))),
                .just(.setReasonString(makeReasonString(
                    reason: deleteAccountReason,
                    directInputText: currentState.directInputText
                )))
            ])

            
            
        case .directInputText(let inputText):
            var isValid = inputText.count <= 100
            var count = inputText.count
            
            // 텍스트뷰의 특성상 placeholder가 텍스트로 들어가기 때문에, 이에 대한 예외처리
            if inputText == "탈퇴하시는 이유를 알려주세요" {
                isValid = true
                count = 0
            }
            
            return .concat([
                .just(.setDirectInputText(inputText)),
                .just(.setDirectInputTextCount(count)),
                .just(.setDirectInputTextValidity(isValid)),
                .just(.enabledButton(checkButtonEnabled(
                    reason: currentState.deleteReason,
                    directInputText: inputText
                ))),
                .just(.setReasonString(makeReasonString(
                    reason: .directInput,
                    directInputText: inputText
                )))
            ])
            
            
        case .confirmButtonTapped:
            // 네트워크 통신
            let reasonString = currentState.reasonString
            
            let requestModel = DeleteAccountRequestModel(
                revokeReason: reasonString
            )
            
            return deleteAccountUseCase.deleteAccountRequest(requestModel)
                .asObservable()
                .map { result in
                    print("탈퇴 결과 : \(result)")
                    
                    return .complete(result)
                }
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
            
        case .complete(let result):
            newState.completeResult = result
//            newState.completeResult = .success(true)
            
        case .setDirectInputText(let text):
            newState.directInputText = text
            
        case .setReasonString(let reasonString):
            newState.reasonString = reasonString
        }
        
        return newState
    }
}



extension DeleteAccountReactor {
    private func checkButtonEnabled(reason: DeleteAccountReason?, directInputText: String) -> Bool {
        guard let reason else { return false }
        // "직접 입력" 외의 이유가 선택된 경우 true
        // "직접 입력"이 선택되고, 텍스트가 존재하는 경우 true
        // 그 외 false
        if reason != .directInput { return true }
        
        else if (reason == .directInput) && (directInputText == "탈퇴하시는 이유를 알려주세요") { return false }
        
        else if (reason == .directInput) && (!directInputText.isEmpty) { return true }
        
        else { return false }
    }
    
    private func makeReasonString(reason: DeleteAccountReason, directInputText: String) -> String {
        var reasonString = ""
        
        if reason != .directInput {
            reasonString = reason.description
        }
        else {
            reasonString = "(직접 입력) \(directInputText)"
        }
        
        return reasonString
    }
}
