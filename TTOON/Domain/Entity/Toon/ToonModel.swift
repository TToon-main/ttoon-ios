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
            mainCharacterId: 2,
            others: [3, 4],
            number: 3,
            title: "오늘의 일기",
            content: "오늘은 오랜만에 학과 동기들과 컨퍼런스를 들으러 가는 날이었다. 오전에 동기 3명과 만나서 서울 코엑스의 전시홀로 향했다. 점심을 먹으러 피자 맛집을 갔는데 정말 맛있었다. 그러고 여러가지 부스를 돌아다니며 게임과 이벤트에 참여했다. 집에 갈 때 퇴근시간이어서 2시간동안 지하철 속 많은 사람들에 껴서 집으로 왔다."
        )
        
        return model
    }
}
