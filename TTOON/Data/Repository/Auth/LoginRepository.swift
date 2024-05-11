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
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser



class LoginRepository: NSObject, LoginRepositoryProtocol {
//    enum SampleError: Error {
//        case sample
//    }
    
    
//    // 애플 로그인의 경우, delegate로 새로운 메서드를 호출하기 때문에 리턴값 대신 프로퍼티를 통해 결과 전달
//    // 전달 방법에 대해 좀 더 고민 필요
//    let resultAppleLogin = PublishSubject<Result<Int, SampleError> >()
//    
    
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
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error  in
                if let error {
                    print("kakao login error : \(error.localizedDescription)")
                } else {
                    print("kakao login success")
                    print("oauth Token : \(oauthToken)")
                    
                    
                    UserApi.shared.me { user, error  in
                        if let error {
                            print("kakao user info error : \(error.localizedDescription)")
                        } else {
                            print("kakao user info success")
                            print("카카오 플랫폼 내 사용자 고유 아이디 : \(user?.id)")
                            
                            /* === 서버 통신 === */
                        }
                    }
                }
            }
        }
    }
    
    func googleLoginRequest(withPresentingVC: UIViewController) {
        print("repo : google Login")
        
        let googleClientID = Bundle.main.infoDictionary?["GIDClientID"] as? String
        let signInConfig = GIDConfiguration(clientID: googleClientID ?? "")
        
        GIDSignIn.sharedInstance.signIn(withPresenting: withPresentingVC) { result, error in
            if let error {
                print("google login error : \(error)")
            } else {
                print("유저 아이디 : \(result?.user.userID)")
                
                /* === 서버 통신 === */
            }
        }
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
