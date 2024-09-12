//
//  SplashErrorReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/22/24.
//

import ReactorKit

import RxSwift

final class SplashErrorReactor: Reactor {
    var sendTransitionEvent: ((SplashReactor.TransitionEvent) -> Void)?
    private let splashUseCase: SplashUseCaseProtocol
    private let splashStatus: SplashStatus
    
    init(splashUseCase: SplashUseCaseProtocol, splashStatus: SplashStatus) {
        self.splashUseCase = splashUseCase
        self.splashStatus = splashStatus
    }
    
    enum Action {
        case viewDidLoad
        case retryButtonTap
    }
    
    enum Mutation {
        case setSplashStatus
        case setRetry
    }
    
    struct State {
        var splashStatus: SplashStatus? = .none
        var moveStore: Void? = .none
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setSplashStatus)

        case .retryButtonTap: 
            return .just(.setRetry)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSplashStatus:
            newState.splashStatus = self.splashStatus

        case .setRetry:
            let status = newState.splashStatus
            
            if status == .disConnected {
                let isConnected = splashUseCase.isNetworkConnected()
                
                if isConnected {
                    if let _ = KeychainStorage.shared.accessToken {
                        sendTransitionEvent?(.goHomeView)  
                    } else {
                        sendTransitionEvent?(.goLoginView)
                    }
                }
            } else if status == .needUpdate {
                newState.moveStore = () 
            }
        }
        
        return newState
    }
}
