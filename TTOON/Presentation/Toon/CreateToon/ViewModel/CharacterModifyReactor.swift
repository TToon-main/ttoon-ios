//
//  CharacterModifyReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import ReactorKit
import RxSwift

final class CharacterModifyReactor: Reactor {
    private let useCase: ToonUseCaseProtocol
    
    init(useCase: ToonUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case refreshList
        case deleteCharacter(String)
        case deletedCharacterTap(DeleteCharacter)
        case addCharacterButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setCharacterList(list: [CharacterPickerTableViewCellDataSource])
        case setEmptyList(isEmpty: Bool)
        case setInvalidList(isInvalid: Bool)
        case setIdleList(isIdle: Bool)
        case setDeletedCharacterTap(DeleteCharacter)
        case setAddCharacterButtonTap
        case setDeleteCharacter(Bool)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var characterList: [CharacterPickerTableViewCellDataSource]? = nil
        var isHiddenEmptyView: Bool = true
        var isHiddenInvalidView: Bool = true
        var isHiddenIdleView: Bool = false
        var presentCharacterDeleteBS: DeleteCharacter? = nil
        var presentCharacterEditorVC: Void? = nil
        var isSuccessDeleted: Bool? = nil
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refreshList:
            return useCase.characterList()
                .map { status in
                    switch status {
                    case .valid(let list):
                        let dataSource = list.map { $0.toPresenter() }
                        return Mutation.setCharacterList(list: dataSource)
                        
                    case .empty:
                        return Mutation.setEmptyList(isEmpty: true)
                        
                    case .invalid:
                        return Mutation.setInvalidList(isInvalid: true)
                        
                    case .idle:
                        return Mutation.setIdleList(isIdle: true)
                    }
                }
            
        case .deletedCharacterTap(let name):
            return .just(.setDeletedCharacterTap(name))

        case .addCharacterButtonTap:
            return  .just(.setAddCharacterButtonTap)
            
        case .deleteCharacter(let id):
            return useCase.deleteCharacter(id: id)
                .map { Mutation.setDeleteCharacter($0)}
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = fetchNewState(state: state)
        
        switch mutation {
        case .setDeletedCharacterTap(let model):
            new.presentCharacterDeleteBS = model
            
        case .setAddCharacterButtonTap:
            new.presentCharacterEditorVC = ()
            
        case .setCharacterList(let list):
            new.characterList = list
            
        case .setEmptyList(let isEmpty):
            new.isHiddenEmptyView = !isEmpty
            
        case .setInvalidList(let isInvalid):
            new.isHiddenInvalidView = !isInvalid
            
        case .setIdleList(let isIdle):
            new.isHiddenIdleView = !isIdle
            
        case .setDeleteCharacter(let isSuccess):
            new.isSuccessDeleted = isSuccess
        }
        
        return new
    }
    
    private func fetchNewState(state: State) -> State {
        var new = state
        new.presentCharacterDeleteBS = nil
        new.presentCharacterEditorVC = nil
        new.isSuccessDeleted = nil
        
        return new
    }
}
