//
//  LoginViewController.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import GoogleSignIn
import RxCocoa
import RxSwift
import UIKit

class LoginViewController: BaseViewController {
    private let mainView = LoginView()
    private var disposeBag = DisposeBag()
    
    
    // 추후 DI (in Coordinator)
    private let viewModel = LoginViewModel(
        loginUseCase: LoginUseCase(
            loginRepository: LoginRepository()
        )
    )
    
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVM()
    }
    
    
    func bindVM() {
        let input = LoginViewModel.Input(
            appleLoginButtonClicked: mainView.appleLoginButton.clearButton.rx.tap,
            kakaoLoginButtonClicked: mainView.kakaoLoginButton.clearButton.rx.tap,
            googleLoginButtonClicked: mainView.googleLoginButton.clearButton.rx.tap,
            // 구글 로그인의 경우, presenting할 VC 매개변수가 필요하기 때문에, 예외적으로 여기서만 VM에게 VC을 알게 한다.
            presentingVC: self
        )
        
        let output = viewModel.transform(input)
    }
}
