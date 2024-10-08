//
//  FeedModel.swift
//  TTOON
//
//  Created by 임승섭 on 9/23/24.
//

import Foundation

// 캘린더 썸네일
struct FeedThumbnailModel: Equatable {
    let id: Int
    let createdDate: String
    let thumbnailUrl: String
}

// 피드 조회
struct FeedModel: Equatable {
    let id: Int
    let title: String
    let imageList: [String]
    let content: String
    let createdDate: String // "yyyy-MM-dd"
    let likes: Int
}


// 피드 조회 (피드 화면)
struct FeedWithInfoModel: Equatable {
    let user: UserInfoModel // user.id는 -1로 저장. 사용하지 않음
    
    let id: Int
    let title: String
    let imageList: [String]
    let content: String
    let createdDate: String // "yyyy-MM-dd"
    let likes: Int
    
    let isMine: Bool
    let likeOrNot: Bool
}
