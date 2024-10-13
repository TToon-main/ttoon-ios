//
//  ToonAPI.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 10/5/24.
//

import Foundation

import Moya

enum ToonAPI {
    case getCharacters
    case deleteCharacter(dto: DeleteCharacterRequestDTO)
    case patchCharacter(dto: PatchCharacterRequestDTO)
    case postCharacter(dto: PostCharacterRequestDTO)
}

extension ToonAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://ttoon.site")!
    }
    
    var path: String {
        switch self {
        case .getCharacters:
            return "/api/character"
        case .deleteCharacter(let dto):
            return "/api/character/\(dto.id)"
        case .patchCharacter:
            return "/api/character"
        case .postCharacter:
            return "/api/character"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharacters:
                return .get

        case .deleteCharacter:
            return .delete

        case .patchCharacter:
            return .patch

        case .postCharacter:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCharacters:
            return .requestPlain

        case .deleteCharacter:
            return .requestPlain

        case .patchCharacter(let dto):
            return .requestJSONEncodable(dto)

        case .postCharacter(let dto):
            return .requestJSONEncodable(dto)
        }
    }
    
    var headers: [String: String]? {
        nil
    }
}
