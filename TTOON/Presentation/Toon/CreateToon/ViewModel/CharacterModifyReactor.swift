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
        case modifyButtonTap(ModifyCharacter)
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setCharacterList(list: [CharacterPickerTableViewCellDataSource])
        case setEmptyList(isEmpty: Bool)
        case setInvalidList(isInvalid: Bool)
        case setDeletedCharacterTap(DeleteCharacter)
        case setAddCharacterButtonTap
        case setDeleteCharacter(Bool)
        case setModifyButtonTap(ModifyCharacter)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var characterList: [CharacterPickerTableViewCellDataSource]? = nil
        var isHiddenEmptyView: Bool = true
        var isHiddenInvalidView: Bool = true
        var presentCharacterDeleteBS: DeleteCharacter? = nil
        var presentCharacterAddVC: Void? = nil
        var presentCharacterEditorVC: ModifyCharacter? = nil
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
                    }
                }
            
        case .deletedCharacterTap(let name):
            return .just(.setDeletedCharacterTap(name))

        case .addCharacterButtonTap:
            return  .just(.setAddCharacterButtonTap)
            
        case .deleteCharacter(let id):
            return useCase.deleteCharacter(id: id)
                .map { Mutation.setDeleteCharacter($0)}
            
        case .modifyButtonTap(let model):
            return .just(.setModifyButtonTap(model))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = fetchNewState(state: state)
        
        switch mutation {
        case .setDeletedCharacterTap(let model):
            new.presentCharacterDeleteBS = model
            
        case .setAddCharacterButtonTap:
            new.presentCharacterAddVC = ()
            
        case .setCharacterList(let list):
            new.characterList = list
            new.isHiddenEmptyView = true
            
        case .setEmptyList(let isEmpty):
            new.isHiddenEmptyView = !isEmpty
            
        case .setInvalidList(let isInvalid):
            new.isHiddenInvalidView = !isInvalid
            new.isHiddenEmptyView = true
            
        case .setDeleteCharacter(let isSuccess):
            new.isSuccessDeleted = isSuccess
            
        case .setModifyButtonTap(let model):
            new.presentCharacterEditorVC = model
        }
        
        return new
    }
    
    private func fetchNewState(state: State) -> State {
        var new = state
        new.presentCharacterDeleteBS = nil
        new.presentCharacterAddVC = nil
        new.presentCharacterEditorVC = nil
        new.isSuccessDeleted = nil
        new.isHiddenEmptyView = true
        
        return new
    }
}
