//
//  FeedDTO.swift
//  TTOON
//
//  Created by 임승섭 on 9/23/24.
//

import Foundation

// 캘린더 썸네일
struct FeedThumbnailDTO: Codable {
    let feedId: Int
    let createdDate: String // "yyyy-MM-dd"
    let thumbnail: String
}
extension FeedThumbnailDTO {
    func toDomain() -> FeedThumbnailModel {
        return .init(
            id: feedId,
            createdDate: createdDate,
            thumbnailUrl: thumbnail
        )
    }
}


// 피드 조회 (단일 - 캘린더 Bottom)
struct FeedDTO: Codable {
    let feedId: Int
    let title: String
    let imageUrl: [String]
    let content: String
    let createdDate: String // "yyyy-MM-dd"
    let likes: Int
}
extension FeedDTO {
    func toDomain() -> FeedModel {
        return .init(
            id: feedId,
            title: title,
            imageList: imageUrl,
            content: content,
            createdDate: createdDate,
            likes: likes
        )
    }
}


// 피드 화면 조회 (전체 조회)
struct FeedWithInfoDTO: Codable {
    let feedId: Int
    let writerName: String
    let writerImage: String?
    let title: String
    let content: String
    let imageUrl: [String]
    let createdDate: String
    let likes: Int
    let isMine: Bool
    let likeOrNot: Bool
    
    func toDomain() -> FeedWithInfoModel {
        return .init(
            user: UserInfoModel(
                friendId: -100,
                profileUrl: writerImage,
                nickname: writerName
            ),
            id: feedId,
            title: title,
            imageList: imageUrl,
            content: content,
            createdDate: createdDate,
            likes: likes,
            isMine: isMine,
            likeOrNot: likeOrNot
        )
    }
}

struct LikeDTO: Codable {
    let like: Int
}


// 좋아요 누른 유저
struct LikeUserDTO: Codable {
    let userName: String
    let userImage: String
    
    func toDomain() -> UserInfoModel {
        return .init(
            friendId: -1,
            profileUrl: userImage,
            nickname: userName
        )
    }
}
