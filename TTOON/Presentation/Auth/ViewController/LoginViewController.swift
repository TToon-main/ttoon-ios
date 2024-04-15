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
            appleLoginButtonClicked: mainView.appleLoginButton.rx.tap,
            kakaoLoginButtonClicked: mainView.kakaoLoginButton.rx.tap,
            googleLoginButtonClicked: mainView.googleLoginButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        
        // google login
        mainView.googleLoginButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.requestGoogleLogin()
            }
            .disposed(by: disposeBag)
    }
    
    func requestGoogleLogin() {
        let googleClientID = Bundle.main.infoDictionary?["GIDClientID"] as? String
        let signInConfig = GIDConfiguration(clientID: googleClientID ?? "")
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error {
                print("google login error : \(error)")
            } else {
                print("유저 아이디 : \(result?.user.userID)")
            }
        }
    }
}
