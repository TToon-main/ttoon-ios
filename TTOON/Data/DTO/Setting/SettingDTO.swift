//
//  SettingDTO.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import Foundation

// 문의하기 - 요청
struct ContactUsRequestDTO {
    let receiver: String // 답변 받을 메일
    let category: String // 문의 유형
    let body: String // 내용
}
extension ContactUsRequestDTO {
    init(_ model: ContactUsRequestModel) {
        self.receiver = model.receiver
        self.category = model.category
        self.body = model.body
    }
}

// 문의하기 - 응답 데이터 x



// 탈퇴하기 - 요청
struct DeleteAccountRequestDTO {
    let revokeReason: String // 탈퇴 이유
}
extension DeleteAccountRequestDTO {
    init(_ model: DeleteAccountRequestModel) {
        self.revokeReason = model.revokeReason
    }
}

// 탈퇴하기 - 응답 데이터 x

struct UserInfoResponseDTO: Codable {
    let nickName: String
    let point: Int
    let email: String
    let provider: String
    let imageUrl: String?
}

extension UserInfoResponseDTO {
    func toDomain() -> UserInfoResponseModel {
        let profileUrl = URL(string: self.imageUrl ?? "") 
        let provider = SocialLoginType(rawValue: provider)!
        let point = String(point)
        
        return UserInfoResponseModel(
            nickName: nickName, 
            profileUrl: profileUrl, 
            email: email, 
            provider: provider, 
            point: point
        )
    }
    
    func toDomain() -> SetProfileResponseModel {
        let profileUrl = URL(string: self.imageUrl ?? "") 
        let provider = SocialLoginType(rawValue: provider)!
        
        let nameStackInfo =  ProfileStackModel(title: "실명", provider: nil, isHiddenCopyButton: true)
        let emailStackInfo =  ProfileStackModel(title: email, provider: provider, isHiddenCopyButton: false)
        
        return SetProfileResponseModel(nickName: nickName,
                                       profileUrl: profileUrl, 
                                       nameStackInfo: nameStackInfo, 
                                       emailStackInfo: emailStackInfo)
    }
}
