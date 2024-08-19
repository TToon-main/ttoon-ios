//
//  SplashUseCase.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation
import RxCocoa
import RxSwift

protocol SplashUseCaseProtocol {
    func isNetworkConnected() -> Bool
    func isMinVersionReached() -> Observable<String>
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
    
    func isMinVersionReached() -> Observable<String> {         
        let getVersionRequest = splashRepository.fetchMinVersion()
        let minVersion = getVersionRequest.compactMap { $0.element }
        
        return minVersion
    }
}
