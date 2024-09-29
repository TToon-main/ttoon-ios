//
//  KeychainStorage.swift
//  TTOON
//
//  Created by 임승섭 on 6/3/24.
//

import Foundation
import SwiftKeychainWrapper

private struct KeychainTokens {
    static let accessTokenKey: String = "TToon.AccessToken.Key"
    static let refreshTokenKey: String = "TToon.RefreshToken.Key"
    static let isAlarmEnabledKey: String = "TToon.isAlarmEnabledKey.Key"
}

final class KeychainStorage {
    static let shared = KeychainStorage()
    private init() { }
    
    var accessToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainTokens.accessTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainTokens.accessTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainTokens.accessTokenKey)
            }
        }
    }
    
    var refreshToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainTokens.refreshTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainTokens.refreshTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainTokens.refreshTokenKey)
            }
        }
    }
    
    var isAlarmEnabled: Bool {
        get {
            KeychainWrapper.standard.bool(forKey: KeychainTokens.isAlarmEnabledKey) ?? false
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: KeychainTokens.isAlarmEnabledKey)
        }
    }
    
    func removeAllKeys() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
