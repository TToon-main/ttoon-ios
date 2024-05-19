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
    func appleLoginRequest() -> PublishSubject<Result<LoginResponseModel, Error>>
    func kakaoLoginRequest() -> PublishSubject<Result<LoginResponseModel, Error>>
    func googleLoginRequest(withPresentingVC: UIViewController) -> PublishSubject<Result<LoginResponseModel, Error>>
}


class LoginUseCase: LoginUseCaseProtocol {
    // MARK: - repository interface
    let loginRepository: LoginRepositoryProtocol
    
    // MARK: - init
    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    // MARK: - method
    func appleLoginRequest() -> PublishSubject<Result<LoginResponseModel, Error>> {
        return loginRepository.appleLoginRequest()
    }
    
    func kakaoLoginRequest() -> PublishSubject<Result<LoginResponseModel, Error>> {
        return loginRepository.kakaoLoginRequest()
    }
    
    func googleLoginRequest(withPresentingVC: UIViewController) -> PublishSubject<Result<LoginResponseModel, Error>> {
        return loginRepository.googleLoginRequest(withPresentingVC: withPresentingVC)
    }
}
