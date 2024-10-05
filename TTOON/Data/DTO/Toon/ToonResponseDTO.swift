//
//  ToonResponseDTO.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

struct GetCharacterResponseDTO: Codable {
    let id: String
    let name: String
    let info: String
    
    func toDomain(mainId: String) -> Character {
        let isMain = id == mainId
        
        return .init(isMain: isMain,
                     id: id,
                     name: name,
                     info: info)
    }
}
