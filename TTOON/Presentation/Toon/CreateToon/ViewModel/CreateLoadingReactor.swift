//
//  CreateLoadingReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/24/24.
//


import ReactorKit
import RxSwift

final class CreateLoadingReactor: Reactor {    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewLifeCycle(cycle: ViewLifeCycle)
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case requestCreateToon(progress: Float)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var currentProgress: Float = 0.0
        var completeProgress: Void? = nil
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewLifeCycle(let cycle):
            switch cycle {
            case .viewWillAppear:
                // TODO: - 네트워크 요청
                return .just(.requestCreateToon(progress: 30))

            default:
                return .never()
            } 
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .requestCreateToon(let progress):
            newState.currentProgress = progress
            
            if progress == 100 {
                newState.completeProgress = ()
            }
        }
        
        return newState
    }
}
