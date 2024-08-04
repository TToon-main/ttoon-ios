//
//  CompleteToonSelectOrderType.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//

import Foundation

enum CompleteToonSelectOrderType {
    case first
    case second 
    case third
    case forth
}

extension CompleteToonSelectOrderType {
    var titleText: String {
        switch self {
        case .first:
            "첫번째 장면에 들어갈\n그림을 선택해주세요"
        case .second:
            "두번째 장면에 들어갈\n그림을 선택해주세요"
        case .third:
            "세번째 장면에 들어갈\n그림을 선택해주세요"
        case .forth:
            "네번째 장면에 들어갈\n그림을 선택해주세요"
        }
    }
}
