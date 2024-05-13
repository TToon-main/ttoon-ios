//
//  LoginResponseModel.swift
//  TTOON
//
//  Created by 임승섭 on 5/13/24.
//

import Foundation

// 로그인 응답 모델
struct LoginResponseModel {
    let accessToken: String
    let refreshToken: String
    let isGuest: Bool   // 아마 추후엔 isGuest 값만 필요하도록 수정 예정
}
