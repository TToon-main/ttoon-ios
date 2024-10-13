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
    let content: String
    
    func toDTO() -> PostToonRequestDTO {
        return .init(mainCharacterId: mainCharacterId,
                     others: others,
                     number: number,
                     title: title,
                     content: content)
    }
    
    func mockUp() -> Self {
        let model = CreateToon.init(
            mainCharacterId: 19,
            others: [20, 21],
            number: 3,
            title: "오늘의 일기",
            content: "오늘 친구들과 강남역에서 만나 커피를 마시고 책을 보며 시간을 보냈다. 다음 여행지로 부산을 정하고, 어디를 갈지 함께 이야기했다. 맛집과 명소들을 알아보며 설레는 마음으로 계획을 세웠고, 이동은 기차를 타기로 결정했다. 부산에서의 새로운 추억이 기대된다."
        )
        
        return model
    }
}
