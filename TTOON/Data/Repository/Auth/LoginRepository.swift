//
//  LoginRepository.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import Foundation
import RxCocoa
import RxSwift

class LoginRepository: LoginRepositoryProtocol {
    func appleLoginRequest() {
        print("repo : apple Login")
    }
    
    func kakaoLoginRequest() {
        print("repo : kakao Login")
    }
    
    func googleLoginRequest() {
        print("repo : google Login")
    }
}
