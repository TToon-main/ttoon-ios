//
//  LoginUseCase.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import RxCocoa
import RxSwift
import UIKit

protocol LoginUseCaseProtocol {
    func appleLoginRequest()
    func kakaoLoginRequest()
    func googleLoginRequest(withPresentingVC: UIViewController)
}


class LoginUseCase: LoginUseCaseProtocol {
    // MARK: - repository interface
    let loginRepository: LoginRepositoryProtocol
    
    // MARK: - init
    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    // MARK: - method
    func appleLoginRequest() {
        loginRepository.appleLoginRequest()
    }
    
    func kakaoLoginRequest() {
        loginRepository.kakaoLoginRequest()
    }
    
    func googleLoginRequest(withPresentingVC: UIViewController) {
        loginRepository.googleLoginRequest(withPresentingVC: withPresentingVC)
    }
}
