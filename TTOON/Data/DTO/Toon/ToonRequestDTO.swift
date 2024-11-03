//
//  ToonRequestDTO.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

struct DeleteCharacterRequestDTO: Encodable {
    let id: String
}

struct PatchCharacterRequestDTO: Encodable {
    let id: String
    let name: String
    let info: String
}

struct PostCharacterRequestDTO: Encodable {
    let name: String
    let info: String
}