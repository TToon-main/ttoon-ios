//
//  LoginViewModel.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import RxCocoa
import RxSwift
import UIKit

class LoginViewModel {
    private let loginUseCase: LoginUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
    
    struct Input {
        let appleLoginButtonClicked: ControlEvent<Void>
        let kakaoLoginButtonClicked: ControlEvent<Void>
        let googleLoginButtonClicked: ControlEvent<Void>
        
        let presentingVC: UIViewController
    }
    
    struct Output {
    }
    
    
    func transform(_ input: Input) -> Output {
        input.appleLoginButtonClicked
            .subscribe(with: self) { owner, _ in
                owner.loginUseCase.appleLoginRequest()
            }
            .disposed(by: disposeBag)
        
        
        input.kakaoLoginButtonClicked
            .subscribe(with: self) { owner, _ in
                owner.loginUseCase.kakaoLoginRequest()
            }
            .disposed(by: disposeBag)
        
        
        input.googleLoginButtonClicked
            .subscribe(with: self) { owner, _ in
                owner.loginUseCase.googleLoginRequest(withPresentingVC: input.presentingVC)            
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
