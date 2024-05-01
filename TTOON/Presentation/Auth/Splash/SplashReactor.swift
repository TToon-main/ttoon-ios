//
//  SplashViewModel.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/18/24.
//

import ReactorKit

import RxSwift

enum SplashStatus {
    case disConnected
    case inMaintenance
    case needUpdate
    case valid
}

final class SplashReactor: Reactor {    
    let splashUseCase: SplashUseCaseProtocol
    
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
              return .just(.setSplashStatus(checkSplashStatus()))
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
    
    private func checkSplashStatus() -> SplashStatus {
        let isConnect = splashUseCase.isNetworkConnected()
        let isMaintenance = splashUseCase.isServerMaintenance()
        let isNeedUpdate = splashUseCase.isMinVersionReached()
        
        if isConnect {
            return .disConnected
        } else if isMaintenance {
            return .inMaintenance
        } else if isNeedUpdate {
            return .needUpdate
        } else {
            return .valid
        }
    }
}
