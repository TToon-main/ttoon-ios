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
    
    static func mockUp() -> Self {
        let model = CreateToon.init(
            mainCharacterId: 6,
            others: [7, 8],
            number: 3,
            title: "일본 여행",
            contentList: [
                "친구랑 같이 점심으로 돈가스를 먹으러 갔다.",
                "밥을 먹고 디저트로 맛있다고 유명한 아이스크림을 먹었다.",
                "배가 불러서 소화 시키기 위해 한강변을 좀 걸었다.",
                "좀 걷다가 심심해져서 친구랑 같이 피씨방에 가서 게임했다."
            ]
        )
        
        return model
    }
}

struct SaveToon: Encodable, Equatable {
    let imageUrls: [URL]
    let feedId: String
    
    func toDTO() -> PostSaveToonRequestDTO {
        return .init(imageUrls: imageUrls, feedId: feedId)
    }
}
