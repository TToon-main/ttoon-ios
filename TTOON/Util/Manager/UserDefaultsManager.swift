//
//  UserDefaultsManager.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import Foundation

enum UserDefaultsManager {
    // 컴파일 최적화 측면 - enum 내부에 선언한다
    enum Key: String {
        case onlyMyFeed
    }
    
    static var onlyMyFeed: Bool {
        get {
            UserDefaults.standard.bool(forKey: Key.onlyMyFeed.rawValue) 
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.onlyMyFeed.rawValue)
        }
    }
}
