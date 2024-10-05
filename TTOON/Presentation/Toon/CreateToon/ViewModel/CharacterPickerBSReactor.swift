//
//  CharacterPickerBSReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/13/24.
//

import ReactorKit
import RxSwift

final class CharacterPickerBSReactor: Reactor {
    private let useCase: ToonUseCaseProtocol
    
    init(useCase: ToonUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case refreshCharacterList
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setCharacterList(list: [Character])
        case setEmptyList(isEmpty: Bool)
        case setInvalidList(isInvalid: Bool)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var characterList: [Character]? = nil
        var isHiddenEmptyView: Bool = true
        var isHiddenInvalidView: Bool = true
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshCharacterList:
            return useCase.characterList()
                .map { status in
                    switch status {
                    case .valid(let list):
                        return Mutation.setCharacterList(list: list)
                        
                    case .empty:
                        return Mutation.setEmptyList(isEmpty: true)
                        
                    case .invalid:
                        return Mutation.setInvalidList(isInvalid: true)
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = fetchNewState(state: state)
        
        switch mutation {
        case .setCharacterList(let list):
            newState.characterList = list
            return newState
            
        case .setEmptyList(let isEmpty):
            newState.isHiddenEmptyView = !isEmpty
            return newState
            
        case .setInvalidList(let isInvalid):
            newState.isHiddenInvalidView = !isInvalid
            return newState
        }
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
        new.isHiddenEmptyView = true
        new.isHiddenInvalidView = true
        
        return new
    }
}
