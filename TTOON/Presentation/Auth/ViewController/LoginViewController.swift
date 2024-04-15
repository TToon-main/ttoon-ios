//
//  LoginViewController.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import RxCocoa
import RxSwift
import UIKit

class LoginViewController: BaseViewController {
    private let mainView = LoginView()
    private var disposeBag = DisposeBag()
    
    
    // 추후 DI
    private let viewModel = LoginViewModel()
    
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
    }
}
