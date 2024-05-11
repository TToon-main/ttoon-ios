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
    func appleLoginRequest()
    func kakaoLoginRequest()
    func googleLoginRequest(withPresentingVC: UIViewController)
}
