//
//  LoginRepositoryProtocol.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import RxCocoa
import RxSwift
import UIKit

protocol LoginRepositoryProtocol {
    func appleLoginRequest() -> PublishSubject<Result<LoginResponseModel, Error>>
    func kakaoLoginRequest() -> PublishSubject<Result<LoginResponseModel, Error>>
    func googleLoginRequest(withPresentingVC: UIViewController) -> PublishSubject<Result<LoginResponseModel, Error>>
}
