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
