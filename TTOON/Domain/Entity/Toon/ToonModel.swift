//
//  ToonModel.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

struct Character {
    let isMain: Bool
    let id: String
    let name: String
    let info: String
    
    func toPresenter() -> CharacterPickerTableViewCellDataSource {
        return .init(id: id,
                     name: name,
                     isMainCharacter: isMain,
                     characterDescription: info,
                     isSelected: false,
                     isModify: false)
    }
}


struct AddCharacter {
    let isMain: Bool
    let name: String
    let info: String
    
    func toDTO() -> PostCharacterRequestDTO {
        return .init(name: name, info: info)
    }
}


struct DeleteCharacter {
    let id: String
    let name: String?
    
    func toDTO() -> DeleteCharacterRequestDTO {
        return .init(id: id)
    }
}

struct ModifyCharacter {
    let id: String
    let name: String
    let info: String
    
    func toDTO() -> PatchCharacterRequestDTO {
        return .init(id: id, name: name, info: info)
    }
}
    
struct CreateToon {
    let mainCharacterId: Int64
    let others: [Int64]
    let number: Int
    let title: String
    let contentList: [String]
    
    func toDTO() -> PostToonRequestDTO {
        return .init(mainCharacterId: mainCharacterId,
                     others: others,
                     number: number,
                     title: title,
                     contentList: contentList)
    }
}

struct SaveToon: Encodable, Equatable {
    let imageUrls: [URL]
    let feedId: String
    
    func toDTO() -> PostSaveToonRequestDTO {
        let imageUrls = imageUrls.map { "\($0)"}
        return .init(imageUrls: imageUrls, feedId: feedId)
    }
}
