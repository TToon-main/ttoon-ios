//
//  FriendDTO.swift
//  TTOON
//
//  Created by 임승섭 on 9/8/24.
//

import Foundation

// 공통
struct UserInfoDTO: Codable {
    let friendId: Int
    let profileUrl: String
    let nickname: String
}
extension UserInfoDTO {
    func toDomain() -> UserInfoModel {
        return .init(
            friendId: friendId,
            profileUrl: profileUrl,
            nickname: nickname
        )
    }
}

// 1. 현재 내 친구 목록 조회
// - 요청 : page: Int
// - 응답
typealias FriendListResponseDTO = [UserInfoDTO]

// 2. 친구 추가
// - 요청 : nickname: String
// - 응답 : x

// 3. 친구 요청 수락
// - 요청 : friendId: Int
// - 응답 : x

// 4. 친구 요청 거절
// - 요청 : friendId: Int
// - 응답 : x

// 5. 친구 삭제
// - 요청 : friendId: Int
// - 응답 : x

// 6. 유저 리스트
// - 요청
struct UserListRequestDTO {
    let searchStr: String
    let page: Int
}
extension UserListRequestDTO {
    init(_ model: UserListRequestModel) {
        self.searchStr = model.searchStr
        self.page = model.page
    }
}
// - 응답
typealias UserListResponseDTO = [SearchedUserInfoDTO]
struct SearchedUserInfoDTO: Codable {
    let friendId: Int
    let profileUrl: String
    let nickname: String
    let status: String
}
extension SearchedUserInfoDTO {
    func toDomain() -> SearchedUserInfoModel {
        return .init(
            userInfo: UserInfoModel(
                friendId: friendId,
                profileUrl: profileUrl,
                nickname: nickname
            ),
            status: status
        )
    }
}
