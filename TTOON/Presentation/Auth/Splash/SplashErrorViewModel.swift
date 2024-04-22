//
//  SplashErrorViewModel.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/22/24.
//


import Foundation

import RxSwift

final class SplashErrorViewModel {
    private let splashUseCase: SplashUseCaseProtocol
    
    init(splashUseCase: SplashUseCaseProtocol) {
        self.splashUseCase = splashUseCase
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let retryButtonTap: Observable<SplashStatus>
    }
    
    struct Output {
        let checkStatus: Observable<Void>
        let isConnected: Observable<Bool>
        let moveStore: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let checkStatus = input.viewDidLoad
        let isConnected = input.retryButtonTap
            .map { $0 == .disConnected }
            .flatMap{ disConnected -> Observable<Bool> in
                if disConnected {
                    .just(self.splashUseCase.isNetworkConnected())
                } else {
                    .never()
                }
            }
        
        let moveStore = input.retryButtonTap
            .map { $0 == .needUpdate }
            .flatMap{ needUpdate -> Observable<Void> in
                if needUpdate {
                    .just(())
                } else {
                    .never()
                }
            }
        
        return Output(checkStatus: checkStatus,
                      isConnected: isConnected,
                      moveStore: moveStore)
    }
}
