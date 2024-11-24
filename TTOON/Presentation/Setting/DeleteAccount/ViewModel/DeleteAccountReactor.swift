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
    private let loginUseCase = LoginUseCase(loginRepository: LoginRepository())
    
    init() { }
    
    enum Action {
        case loadData
        case deleteReason(DeleteAccountReason)  // 탈퇴하는 이유 저장
        case directInputText(String)
        case confirmButtonTapped                // 얼럿에서 탈퇴 버튼을 클릭한 경우
        
        case deleteAccountWithApple
    }
    
    enum Mutation {
        case setUserInfo(nickname: String, socialType: SocialLoginType)
        case setReason(DeleteAccountReason)
        case showTextView(Bool)
        case setDirectInputText(String)
        case setDirectInputTextValidity(Bool)
        case setDirectInputTextCount(Int)
        case enabledButton(Bool)
        case complete                           // 탈퇴 성공 시 state의 completeResult를 true로 바꿔줌
        
        // 네트워크 통신 요청에 필요한 정보 : 탈퇴 이유
        // 직접 입력 : "(직접 입력) : ~~~~"
        // 그 외 : "생성되는 이미지가 마음에 들지 않아서"
        case setReasonString(String)
        
        
        case setGoDeleteAccountWithApple
        
        case pass
    }
    
    struct State {
        var userNickname: String = "알 수 없음"
        var userSocialLoginType: SocialLoginType = .apple
        
        var deleteReason: DeleteAccountReason?
        var showTextView: Bool = false
        var directInputText: String = "" // 일단 쓰자. 필요하다.
        var directInputTextValid: Bool = true
        var directInputTextCount: Int = 0
        var buttonEnabled: Bool = false
        var completeResult: Bool = false    // 탈퇴 성공 시 true로 바뀜
        
        
        // 네트워크 통신 요청에 필요한 정보
        var reasonString: String = ""
        
        
        var goDeleteAccountWithApple: Bool = false  // 애플 재로그인 성공 시 true로 변경
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadData:
            return deleteAccountUseCase.getUserInfo()
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let userInfo):
                        return .setUserInfo(
                            nickname: userInfo.nickName,
                            socialType: userInfo.provider)

                    case .failure:
                        return .setUserInfo(
                            nickname: "알 수 없음",
                            socialType: .apple)
                    }
                }
            
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
            if currentState.userSocialLoginType == .apple {
                // 애플 로그인 요청
                return loginUseCase.appleLoginRequest()
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success:
                            return .setGoDeleteAccountWithApple

                        case .failure:
                            return .pass
                        }
                    }
            }
            
            else {
                // 탈퇴 요청 네트워크 통신
                let reasonString = currentState.reasonString
                let requestModel = DeleteAccountRequestModel(
                    authorizationCode: nil,
                    revokeReason: reasonString
                )
                return deleteAccountUseCase.deleteAccountRequest(requestModel)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success:
                            return .complete
                            
                        case .failure:
                            return .pass
                        }
                    }
            }
            
            
        // 애플 재로그인이 성공 시 아래 코드 실행
        case .deleteAccountWithApple:
            let reasonString = currentState.reasonString
            let requestModel = DeleteAccountRequestModel(
                authorizationCode: KeychainStorage.shared.appleIdToken, 
                revokeReason: reasonString
            )
            return deleteAccountUseCase.deleteAccountRequest(requestModel)
                .asObservable()
                .map { result in
                    switch result {
                    case .success:
                        return .complete
                        
                    case .failure:
                        return .pass
                    }
                }
        }
    }
    
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUserInfo(let nickname, let socialType):
            newState.userNickname = nickname
            newState.userSocialLoginType = socialType
            
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
            newState.completeResult = true
            
        case .setDirectInputText(let text):
            newState.directInputText = text
            
        case .setReasonString(let reasonString):
            newState.reasonString = reasonString
        
        case .pass:
            print("pass case")
            
        case .setGoDeleteAccountWithApple:
            newState.goDeleteAccountWithApple = true
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
