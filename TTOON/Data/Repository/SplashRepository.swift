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
    
    func fetchServerMaintenance() {
        print("서버 점검 여부")
    }
    
    func fetchMinVersion() {
        print("최소 버전")
    }
}
