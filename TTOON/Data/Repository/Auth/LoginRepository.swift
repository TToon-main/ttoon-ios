//
//  LoginRepository.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import Foundation
import RxCocoa
import RxSwift

import AuthenticationServices



class LoginRepository: NSObject, LoginRepositoryProtocol {
    
    enum SampleError: Error {
        case sample
    }
    
    
    // 애플 로그인의 경우, delegate로 새로운 메서드를 호출하기 때문에 리턴값 대신 프로퍼티를 통해 결과 전달
    // 전달 방법에 대해 좀 더 고민 필요
    let resultAppleLogin = PublishSubject<Result<Int, SampleError> >()
    
    
    func appleLoginRequest() {
        print("repo : apple Login")
        
        // 1. apple ID provider request
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func kakaoLoginRequest() {
        print("repo : kakao Login")
    }
    
    func googleLoginRequest() {
        print("repo : google Login")
    }
}



// MARK: - Apple Login
extension LoginRepository: ASAuthorizationControllerDelegate {
    // apple login success
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("apple login success")
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("user 고유 식별자 : \(appleIDCredential.user)")
            
            /* === 서버 통신 === */
        } else {
            
        }
    }
    
    
    // apple login failure
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failure")
    }
}
