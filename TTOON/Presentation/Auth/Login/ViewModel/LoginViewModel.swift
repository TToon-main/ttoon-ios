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
        
        let presentingVC: UIViewController  // 구글 로그인 구현 시 presentingVC가 필요함 (repo로 전달)
    }
    
    struct Output {
    }
    
    
    func transform(_ input: Input) -> Output {
        input.appleLoginButtonClicked
            .withUnretained(self)
            .flatMap { _ in                
                self.loginUseCase.appleLoginRequest()
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let data):
                    print("애플 로그인 성공 : ", data)
                    
                case .failure(let error):
                    print("애플 로그인 실패 : ", error)
                }
            }
            .disposed(by: disposeBag)
            
        
        input.kakaoLoginButtonClicked
            .withUnretained(self)
            .flatMap { _ in
                self.loginUseCase.kakaoLoginRequest()
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let data):
                    print("카카오 로그인 성공 : ", data)
                    
                case .failure(let error):
                    print("카카오 로그인 실패 : ", error)
                }
            }
            .disposed(by: disposeBag)
        
        
        input.googleLoginButtonClicked
            .withUnretained(self)
            .flatMap { _ in
                self.loginUseCase.googleLoginRequest(withPresentingVC: input.presentingVC)
            }
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let data):
                    print("구글 로그인 성공 : ", data)
                    
                case .failure(let error):
                    print("구글 로그인 실패 : ", error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        
        
        
        return Output()
    }
}
