//
//  SplashUsecase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol SplashUseCaseProtocol {
    func isNetworkConnected() -> Bool
    func isMinVersionReached() -> Bool
}

class SplashUseCase: SplashUseCaseProtocol {
    // MARK: - repository interface
    let splashRepository: SplashRepositoryProtocol
    
    // MARK: - init
    init(splashRepository: SplashRepositoryProtocol) {
        self.splashRepository = splashRepository
    }
    
    // MARK: - method
    
    func isNetworkConnected() -> Bool {
        return splashRepository.fetchNetworkStatus()
    }
    
    func isMinVersionReached() -> Bool {        
        guard let nowVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            print("현재 버전을 찾을 수 없음")
            return false
        }
        
        let minimumVersion = splashRepository.fetchMinVersion()
        
        let compare: (String, String) -> Bool = { $0.compare($1, options: .numeric) == .orderedAscending }
        
        return compare(nowVersion, minimumVersion)
    }
}
