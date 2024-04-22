//
//  SplashViewModel.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation

import RxSwift

enum SplashStatus {
    case disConnected
    case inMaintenance
    case needUpdate
    case valid
}

final class SplashViewModel {
    let splashUseCase: SplashUseCaseProtocol
    
    init(splashUseCase: SplashUseCaseProtocol) {
        self.splashUseCase = splashUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let splashStatus: Observable<SplashStatus>
    }
    
    func transform(input: Input) -> Output {
        let viewDidLoad = input.viewDidLoad
        
        let splashStatus = viewDidLoad.flatMap { _ -> Observable<SplashStatus> in
            return .create { observer in
                let isConnect = self.splashUseCase.isNetworkConnected()
                let isMaintenance = self.splashUseCase.isServerMaintenance()
                let isNeedUpdate = self.splashUseCase.isMinVersionReached()
                
                if !isConnect {
                    observer.onNext(.disConnected)
                } else if isMaintenance {
                    observer.onNext(.inMaintenance)
                } else if isNeedUpdate {
                    observer.onNext(.needUpdate)
                } else {
                    observer.onNext(.valid)
                }
                return Disposables.create()
            }
        }
        
        return Output(splashStatus: splashStatus)
    }
}
