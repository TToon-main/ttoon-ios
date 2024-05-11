//
//  SocialLoginEnum.swift
//  TTOON
//
//  Created by 임승섭 on 5/11/24.
//

import UIKit

enum SocialLoginType {
    case apple
    case kakao
    case google
    
    var buttonImage: UIImage {
        switch self {
        case .apple:
            return .socialLoginImageApple

        case .kakao:
            return .socialLoginImageKakao

        case .google:
            return .socialLoginImageGoogle
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .apple:
            return "Apple로 계속하기"
        case .kakao:
            return "카카오로 시작하기"
        case .google:
            return "Google로 시작하기"
        }
    }
    
    var buttonTitleColor: UIColor {
        switch self {
        case .apple:
            return .white

        case .kakao:
            return .black.withAlphaComponent(0.85)

        case .google:
            return .black.withAlphaComponent(0.54)
        }
    }
    
    var buttonBackgroundColor: UIColor {
        switch self {
        case .apple:
            return .black

        case .kakao:
            return UIColor(hexString: "#FEE500")!

        case .google:
            return .white
        }
    }
    
    var buttonBorderColor: UIColor {
        switch self {
        case .apple:
            return .black

        case .kakao:
            return UIColor(hexString: "#FEE500")!

        case .google:
            return UIColor(hexString: "#D3D3D3")!
        }
    }
}
