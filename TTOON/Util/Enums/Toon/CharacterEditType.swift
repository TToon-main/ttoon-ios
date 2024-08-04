//
//  CharacterEditType.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/28/24.
//

import Foundation

enum CharacterEditType {
    case add
    case edit
}

extension CharacterEditType {
    var isHiddenTitleLabel: Bool {
        switch self {
        case .add: return false
        case .edit: return true
        }
    }
    
    var isHiddenDeleteButton: Bool {
        switch self {
        case .add: return true
        case .edit: return false
        }
    }
}
