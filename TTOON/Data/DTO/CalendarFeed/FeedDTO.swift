//
//  FeedDTO.swift
//  TTOON
//
//  Created by 임승섭 on 9/23/24.
//

import Foundation

// 캘린더 썸네일
struct FeedThumbnailDTO: Codable {
    let id: Int
    let createdDate: String // "yyyy-MM-dd"
    let thumbnailUrl: String
}
extension FeedThumbnailDTO {
    func toDomain() -> FeedThumbnailModel {
        return .init(
            id: id,
            createdDate: createdDate,
            thumbnailUrl: thumbnailUrl
        )
    }
}


// 피드 조회
struct FeedDTO: Codable {
    let id: Int
    let title: String
    let imageList: [ImageUrl]
    let content: String
    let createdDate: String // "yyyy-MM-dd"
    let like: Int
    
    struct ImageUrl: Codable {
        let imageUrl: String
    }
}
extension FeedDTO {
    func toDomain() -> FeedModel {
        return .init(
            id: id,
            title: title,
            imageList: imageList.map { $0.imageUrl },
            content: content,
            createdDate: createdDate,
            like: like
        )
    }
}
