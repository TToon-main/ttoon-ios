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

enum SampleError: Error {
    case a
}



class LoginRepository: NSObject, LoginRepositoryProtocol {
//    // 애플 로그인의 경우, delegate로 새로운 메서드를 호출하기 때문에 리턴값 대신 프로퍼티를 통해 결과 전달
//    // 전달 방법에 대해 좀 더 고민 필요
//    let resultAppleLogin = PublishSubject<Result<Int, SampleError> >()
    
    
    // 소셜 로그인 결과 전달하는 방법에 대해 고민 필요
    private var loginResult = PublishSubject<Result<LoginResponseModel, Error>>()
    
    private let provider = APIProvider<LoginAPI>()
    
    func appleLoginRequest() -> PublishSubject<Result<LoginResponseModel, Error>> {
        
        loginResult = PublishSubject<Result<LoginResponseModel, Error>>()
        
        // 1. apple ID provider request
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
        
        return loginResult
    }
    
    func kakaoLoginRequest() -> PublishSubject<Result<LoginResponseModel, Error>> {
        
        loginResult = PublishSubject<Result<LoginResponseModel, Error>>()
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error  in
                if let error {
                    print("kakao login error : \(error.localizedDescription)")
                } else {
                    UserApi.shared.me { [weak self] user, error  in
                        if let error {
                            print("kakao user info error : \(error.localizedDescription)")
                        } else {
                            guard let id = user?.id, let email = user?.kakaoAccount?.email else { return }
                            print("카카오 유저 아이디 : \(id)")
                            print("카카오 유저 이메일 : \(email)")
                            
                            let requestDTO = LoginRequestDTO(provider: "KAKAO", providerID: String(id), email: email)
                            self?.loginRequest(requestDTO)
                        }
                    }
                }
            }
        }
        
        // 카카오 로그인에 대한 실패 케이스 예외처리 필요.
        
        return loginResult
    }
    
    func googleLoginRequest(withPresentingVC: UIViewController) -> PublishSubject<Result<LoginResponseModel, Error>> {
        
        loginResult = PublishSubject<Result<LoginResponseModel, Error>>()
        
//        let googleClientID = Bundle.main.infoDictionary?["GIDClientID"] as? String
//        let signInConfig = GIDConfiguration(clientID: googleClientID ?? "")
        
        GIDSignIn.sharedInstance.signIn(withPresenting: withPresentingVC) { result, error in
            if let error {
                print("google login error : \(error)")
            } else {
                guard let id = result?.user.userID, let email = result?.user.profile?.email else { return }
                
                print("구글 유저 아이디 : \(id)")
                print("구글 유저 이메일 : \(email)")
                
                let requestDTO = LoginRequestDTO(provider: "GOOGLE", providerID: String(id), email: email)
                self.loginRequest(requestDTO)
            }
        }
        
        return loginResult
    }
}



// MARK: - Apple Login
extension LoginRepository: ASAuthorizationControllerDelegate {
    // apple login success
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("apple login success")
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let tokenString = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8) {
            let id = appleIDCredential.user
            let email = decode(jwtToken: tokenString)["email"] as? String ?? ""
            
            
            print("애플 유저 아이디 : \(id)")
            print("애플 유저 이메일 : \(email)")
            
            let requestDTO = LoginRequestDTO(provider: "APPLE", providerID: String(id), email: email)
            self.loginRequest(requestDTO)
        } else {
        }
    }
    
    
    // apple login failure
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failure")
    }
}


// MARK: - Login API Request
extension LoginRepository {
    func loginRequest(_ requestDTO: LoginRequestDTO) {
        self.provider.unAuthProvider.request(
            .socialLogin(dto: requestDTO)) { result in
                switch result {
                case .success(let response):
                    // 통신을 해보면, 성공 실패 모두 여기로 응답이 온다. (200, 401)
                    
                    print("statusCode : ", response.statusCode)
                    
                    // 성공
                    if let data = try? response.map(ResponseSuccessDTO<LoginResponseDTO>.self) {
                        print("성공 : ", data)
                        
                        // 결과 VM으로 전달
                        self.loginResult.onNext(.success(data.data.toDomain()))
                    }
                    
                    // 실패
                    else {
                        // 결과 VM으로 전달
                        self.loginResult.onNext(.failure(SampleError.a))
                    }
                        
                case .failure(let error):
                
                    print(error.localizedDescription)
                    
                    // 결과 VM으로 전달
                    self.loginResult.onNext(.failure(error))
                }
        }
    }
}


// MARK: - private func
extension LoginRepository {
    // jwt token decoding
    private func decode(jwtToken jwt: String) -> [String: Any] {
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
//                base64 = base64 + padding
                base64 += padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }

        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }

            return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
}
