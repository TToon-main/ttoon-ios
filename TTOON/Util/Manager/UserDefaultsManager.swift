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
        case mainCharacterId
        case toonInfoTitle
        case toonInfoContents
    }
    
    static var onlyMyFeed: Bool {
        get {
            UserDefaults.standard.bool(forKey: Key.onlyMyFeed.rawValue) 
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.onlyMyFeed.rawValue)
        }
    }
    
    static var mainCharacterId: String {
        get {
            UserDefaults.standard.string(forKey: Key.mainCharacterId.rawValue) ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Key.mainCharacterId.rawValue)
        }
    }
    
    static var toonInfoTitle: String {
        get {
            UserDefaults.standard.string(forKey: Key.toonInfoTitle.rawValue) ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Key.toonInfoTitle.rawValue)
        }
    }
    
    static var toonInfoContents: String {
        get {
            UserDefaults.standard.string(forKey: Key.toonInfoContents.rawValue) ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Key.toonInfoContents.rawValue)
        }
    }
}
