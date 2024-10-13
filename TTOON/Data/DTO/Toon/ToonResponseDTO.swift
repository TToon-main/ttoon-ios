//
//  ToonResponseDTO.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

struct GetCharacterResponseDTO: Codable {
    let id: Int64
    let name: String
    let info: String
    
    func toDomain(mainId: String) -> Character {
        let isMain = "\(id)" == mainId
        
        return .init(isMain: isMain,
                     id: "\(id)",
                     name: name,
                     info: info)
    }
}

struct CharacterResponseDTO: Codable {
    let figureId: Int64
}

struct PostToonResponseDTO: Codable {
    let feedId: Int64
    let imageUrls: [String]
}
