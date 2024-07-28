//
//  SettingResponseModel.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation

// 문의하기 - 요청
struct ContactUsRequestModel {
    let receiver: String
    let category: String
    let body: String
}

// 문의하기 - 응답 데이터 x


// 탈퇴하기 - 요청
struct DeleteAccountRequestModel {
    let revokeReason: String
}

// 탈퇴하기 - 응답 데이터 x