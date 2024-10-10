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
    let like: Int
}
