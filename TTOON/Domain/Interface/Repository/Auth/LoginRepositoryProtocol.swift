//
//  LoginRepositoryProtocol.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol LoginRepositoryProtocol {
    func appleLoginRequest()
    func kakaoLoginRequest()
    func googleLoginRequest()
}
