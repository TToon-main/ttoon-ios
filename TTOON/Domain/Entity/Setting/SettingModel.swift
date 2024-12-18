//
//  SettingResponseModel.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import UIKit

// 문의하기 - 요청
struct ContactUsRequestModel {
    let receiver: String
    let category: String
    let body: String
}

// 문의하기 - 응답 데이터 x


// 탈퇴하기 - 요청
struct DeleteAccountRequestModel {
    let authorizationCode: String?
    let revokeReason: String
}

// 탈퇴하기 - 응답 데이터 x

// 프로필 조회
struct UserInfoResponseModel {
    let nickName: String
    let profileUrl: URL?
    let email: String
    let provider: SocialLoginType
    let point: String
}

struct SetProfileResponseModel {
    let nickName: String
    let profileUrl: URL?
    let nameStackInfo: ProfileStackModel
    let emailStackInfo: ProfileStackModel
}

struct ProfileStackModel {
    let title: String
    let provider: SocialLoginType?
    let isHiddenCopyButton: Bool
}

class SetProfileRequestModel {
    var nickName: String
    var isDelete: Bool
    var image: UIImage?
    
    init(nickName: String, isDelete: Bool, image: UIImage? = nil) {
        self.nickName = nickName
        self.isDelete = isDelete
        self.image = image
    }
    
    func toDTO() -> PatchProfileRequestDTO {
        return PatchProfileRequestDTO(nickName: nickName,
                                     isDelete: isDelete,
                                     image: image)
    }
}
