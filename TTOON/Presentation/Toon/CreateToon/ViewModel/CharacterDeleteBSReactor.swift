//
//  CharacterDeleteBSReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import ReactorKit
import RxSwift

protocol CharacterDeleteBSReactorDelegate: AnyObject {
    func deleteCharacter(id: String?)
}

final class CharacterDeleteBSReactor: Reactor {    
    private let model: DeleteCharacter?
    weak var delegate: CharacterDeleteBSReactorDelegate?
    
    init(model: DeleteCharacter?) {
        self.model = model
    }
    
    enum Action {
        case viewDidLoad
        case backButtonTap
        case deleteButtonTap
    }
    
    enum Mutation {
        case setCharacterName(name: String?)
        case setDismiss
    }
    
    struct State {
        var userName: String? = nil
        var dismiss: Void? = nil
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let name = model?.name
            return .just(.setCharacterName(name: name))
            
        case .backButtonTap:
            return .just(.setDismiss)
            
        case .deleteButtonTap:
            let id = self.model?.id
            delegate?.deleteCharacter(id: id)
            return .just(.setDismiss)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCharacterName(let name):
            newState.userName = name
            
        case .setDismiss:
            newState.dismiss = ()
        }
        
        return newState
    }
}
