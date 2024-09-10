//
//  ValidationManager.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import Foundation

class ValidationManager {
    static let shared = ValidationManager()
    private init() { }
    
    func truncateText(_ text: String, limit: Int = 10) -> String {
        if text.count > limit {
            let index = text.index(text.startIndex, offsetBy: limit)
            return String(text[text.startIndex..<index]) 
        }
        
        return text 
    }
}
