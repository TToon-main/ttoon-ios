//
//  SplashRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation

class SplashRepository: SplashRepositoryProtocol {
    func fetchNetworkStatus() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
    
    func fetchMinVersion() -> String {
        return "1.0"
    }
}
