//
//  CharacterDeleteBSReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import ReactorKit
import RxSwift

final class CharacterDeleteBSReactor: Reactor {    
    let userName: String?
    
    init(userName: String?) {
        self.userName = userName
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewLifeCycle(ViewLifeCycle)
        case backButtonTap
        case deleteButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setViewLifeCycle(ViewLifeCycle)
        case setDismiss
    }
    
    // 뷰에 전달할 상태
    struct State {
        var userName: String? = nil
        var dismiss: Void? = nil
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewLifeCycle(let cycle): 
            return .just(.setViewLifeCycle(cycle))   
            
        case .backButtonTap:
            return .just(.setDismiss)
            
        case .deleteButtonTap:
            // TODO: api 요청
            return .just(.setDismiss)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setViewLifeCycle(let cycle):
            if cycle == .viewWillAppear {
                newState.userName = self.userName
            }
            
        case .setDismiss:
            newState.dismiss = ()
        }
        
        return newState
    }
}
