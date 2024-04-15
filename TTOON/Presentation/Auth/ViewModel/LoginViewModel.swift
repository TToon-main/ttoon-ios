//
//  LoginViewModel.swift
//  TTOON
//
//  Created by 임승섭 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa


class LoginViewModel {
    
    struct Input {
        let appleLoginButtonClicked: ControlEvent<Void>
        let kakaoLoginButtonClicked: ControlEvent<Void>
        let googleLoginButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    
    func transform(_ input: Input) -> Output {
        
        
        return Output()
    }
    
    
    
}
