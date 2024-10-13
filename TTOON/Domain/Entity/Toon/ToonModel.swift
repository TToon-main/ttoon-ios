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
    
    static func mockUp() -> Self {
        let model = CreateToon.init(
            mainCharacterId: 19,
            others: [20, 21],
            number: 3,
            title: "오늘의 일기",
            content: "2024년 10월 13일, 오늘은 가을이 한창 무르익은 날이었다. 아침에 일어나 창밖을 보니 노란 단풍이 절경이었다. 친구와 함께 공원으로 산책을 나갔고, 따뜻한 햇살 아래서 이야기를 나누며 웃음이 끊이지 않았다. 저녁에는 따뜻한 차 한 잔과 함께 책을 읽으며 하루를 마무리했다. 이런 소소한 일상이 행복을 준다"
        )
        
        return model
    }
}
