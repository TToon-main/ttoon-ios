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

enum LoginError: Error {
    case appleError // 애플 서버 에러
    case kakaoError // 카카오 서버 에러
    case googleError // 구글 서버 에러
    case ttoonError // TToon 서버 에러
    case otherError(description: String) // 기타
}



class LoginRepository: NSObject, LoginRepositoryProtocol {
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
        
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error  in
                if let error {
                    print("kakao login error : \(error.localizedDescription)")
                    self.loginResult.onNext(.failure(LoginError.kakaoError))
                } else {
                    UserApi.shared.me { [weak self] user, error  in
                        if let error {
                            print("kakao user info error : \(error.localizedDescription)")
                            self?.loginResult.onNext(.failure(LoginError.kakaoError))
                        } else {
                            guard let id = user?.id, let email = user?.kakaoAccount?.email else { return }

                            let requestDTO = LoginRequestDTO(
                                providerID: String(id),
                                provider: "KAKAO",
                                email: email
                            )
                            self?.loginRequest(requestDTO)
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error  in
                if let error {
                    print("kakao login error : \(error.localizedDescription)")
                    self.loginResult.onNext(.failure(LoginError.kakaoError))
                } else {
                    UserApi.shared.me { [weak self] user, error  in
                        if let error {
                            print("kakao user info error : \(error.localizedDescription)")
                            self?.loginResult.onNext(.failure(LoginError.kakaoError))
                        } else {
                            guard let id = user?.id, let email = user?.kakaoAccount?.email else { return }

                            let requestDTO = LoginRequestDTO(
                                providerID: String(id),
                                provider: "KAKAO",
                                email: email
                            )
                            self?.loginRequest(requestDTO)
                        }
                    }
                }
            }
        }
        
        
        return loginResult
    }
    
    func googleLoginRequest(withPresentingVC: UIViewController) -> PublishSubject<Result<LoginResponseModel, Error>> {
        loginResult = PublishSubject<Result<LoginResponseModel, Error>>()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: withPresentingVC) { result, error in
            if let error {
                print("google login error : \(error)")
                self.loginResult.onNext(.failure(LoginError.googleError))
            } else {
                guard let id = result?.user.userID, let email = result?.user.profile?.email else { return }

                let requestDTO = LoginRequestDTO(
                    providerID: String(id),
                    provider: "GOOGLE",
                    email: email
                )
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
           let tokenString = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8),
           let authorizationCode = String(data: appleIDCredential.authorizationCode ?? Data(), encoding: .utf8)
        {
            let id = appleIDCredential.user
            let email = decode(jwtToken: tokenString)["email"] as? String ?? ""
            KeychainStorage.shared.appleIdToken = authorizationCode
            
            let requestDTO = LoginRequestDTO(providerID: String(id), provider: "APPLE", email: email)
            self.loginRequest(requestDTO)
        } else {
            self.loginResult.onNext(.failure(LoginError.appleError))
        }
    }
    
    
    // apple login failure
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failure")
        
        self.loginResult.onNext(.failure(LoginError.appleError))
    }
}

// MARK: - Login API Request
extension LoginRepository {
    func loginRequest(_ requestDTO: LoginRequestDTO) {
        self.provider.unAuth.request(
            .socialLogin(dto: requestDTO)) { result in
                switch result {
                case .success(let response):
                    // Moya는 서버와 통신 자체가 성공하기만 하면 success
                    // 응답 데이터 디코딩
                    if let data = try? response.map(ResponseDTO<LoginResponseDTO>.self) {
                        // 성공
                        if data.isSuccess, let responseData = data.data {
                            // 키체인 토큰 업데이트
                            KeychainStorage.shared.accessToken = responseData.accessToken
                            KeychainStorage.shared.refreshToken = responseData.refreshToken
                            
                            print("키체인 업데이트 완료")
                            print("access : \(KeychainStorage.shared.accessToken)")
                            print("refesh : \(KeychainStorage.shared.refreshToken)")
                            
                            
                            self.loginResult.onNext(.success(responseData.toDomain()))
                        }
                        // 실패
                        else {
                            self.loginResult.onNext(.failure(LoginError.ttoonError))
                        }
                    }
                    else {
                        print("*")
                        print(response.response)
                        self.loginResult.onNext(.failure(LoginError.ttoonError))
                    }
                        
                case .failure(let error):
                
                    print(error.localizedDescription)
                    
                    // 결과 VM으로 전달
                    self.loginResult.onNext(.failure(LoginError.otherError(description: error.localizedDescription)))
                }
        }
    }
}


// MARK: - private func
extension LoginRepository {
    // decode email from JWT
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
