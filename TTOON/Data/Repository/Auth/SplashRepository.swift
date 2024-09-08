//
//  SplashRepository.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation

import RxMoya
import RxSwift

class SplashRepository: SplashRepositoryProtocol {
    let provider = APIProvider<SplashAPI>()
    
    func fetchNetworkStatus() -> Bool {
        return NetworkMonitor.shared.isConnected
    }
    
    func fetchMinVersion() -> Observable<Event<String>> {
        return provider.unAuth.rx.request(.getMinVersion)
            .map(ResponseDTO<String>.self)
            .compactMap { $0.data }
            .asObservable()
            .materialize()
    }
}
