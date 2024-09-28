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


// 피드 조회
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
            like: likes
        )
    }
}
