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
    case needUpdate
    case valid
}

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
              return .just(.setSplashStatus(checkSplashStatus()))
          }
      }
        
      // 사실상 ViewController에 Output 전달이 필요하지 않아 보인다.
      func reduce(state: State, mutation: Mutation) -> State {
          var newState = state
          switch mutation {
          case .setSplashStatus(let status):
              newState.splashStatus = status
          }
          return newState
      }
    
    
    // 위치가 적절한 지는 의문이지만, 여기서 코디로 이벤트 전달!
    private func checkSplashStatus() -> SplashStatus {
        let isConnect = splashUseCase.isNetworkConnected()
        let isNeedUpdate = splashUseCase.isMinVersionReached()

        
        if isConnect {
            sendTransitionEvent?(.goSplashErrorView(.disConnected))
            return .disConnected 
        } else if isNeedUpdate {
            sendTransitionEvent?(.goSplashErrorView(.needUpdate))
            return .needUpdate
        } else {
            // 여기서 토큰 여부 확인! (기존 VC에 있던 코드)
            let isTokenValid = false
            
            sendTransitionEvent?( 
                (isTokenValid) ? .goHomeView : .goLoginView
            )
            
            return .valid
        }
    }
}

// 코디네이터에게 전달할 화면 전환 이벤트
extension SplashReactor {
    enum TransitionEvent {
        case goSplashErrorView(SplashStatus)    // 무슨 에러인지까지 전달해준다
        // disConnected, inMaintenance, needUpdate
        
        case goLoginView
        case goHomeView
    }
}
