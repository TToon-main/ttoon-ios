//
//  SplashViewModel.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import Foundation
import ReactorKit

import RxSwift

final class SplashReactor: Reactor {    
    let splashUseCase: SplashUseCaseProtocol
    
    var sendTransitionEvent: ((SplashReactor.TransitionEvent) -> Void)?
    
    init(splashUseCase: SplashUseCaseProtocol) {
        self.splashUseCase = splashUseCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewDidLoad
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setSplashStatus(SplashStatus)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var splashStatus: SplashStatus? = .none
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return checkSplashStatus().map { status in
                return Mutation.setSplashStatus(status)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSplashStatus(let status):
            newState.splashStatus = status
        }
        
        return newState
    }
    
    private func checkSplashStatus() -> Observable<SplashStatus> {
        let isConnect = splashUseCase.isNetworkConnected()
        
        return splashUseCase.isMinVersionReached()
            .flatMap { minVersion -> Observable<SplashStatus> in
                if isConnect {
                    self.sendTransitionEvent?(.goSplashErrorView(.disConnected))
                    return .just(.disConnected)
                } else if self.isMinVersionReached(minVersion) { 
                    self.sendTransitionEvent?(.goSplashErrorView(.needUpdate))
                    return .just(.needUpdate)
                } else {
                    let isTokenValid = false
                    self.sendTransitionEvent?(isTokenValid ? .goHomeView : .goLoginView)
                    return .just(.valid)
                }
            }
    }
    
    private func isMinVersionReached(_ version: String) -> Bool {
        return version.compare(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "", options: .numeric) == .orderedAscending
    }
}

extension SplashReactor {
    enum SplashStatus {
        case disConnected
        case needUpdate
        case valid
    }
    
    enum TransitionEvent {
        case goSplashErrorView(SplashStatus) 
        case goLoginView
        case goHomeView
    }
}
