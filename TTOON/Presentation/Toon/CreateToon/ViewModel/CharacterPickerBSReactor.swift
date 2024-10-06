//
//  CharacterPickerBSReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/13/24.
//

import ReactorKit
import RxSwift

protocol CharacterPickerBSDelegate: AnyObject {
    func presentModifyCharacterViewController()
    func selectedCharacters(selectedModels: [CharacterPickerTableViewCellDataSource])
}

final class CharacterPickerBSReactor: Reactor {
    private let useCase: ToonUseCaseProtocol
    weak var delegate: CharacterPickerBSDelegate?
    
    init(useCase: ToonUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case refreshCharacterList
        case modifyCharacterButtonTap
        case confirmButtonTap
        case modelSelected(model: CharacterPickerTableViewCellDataSource)
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setCharacterList(list: [CharacterPickerTableViewCellDataSource])
        case setEmptyList(isEmpty: Bool)
        case setInvalidList(isInvalid: Bool)
        case setDismiss(isDismiss: Bool)
        case setIsEnabledConfirmButton(isEnabled: Bool)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var characterList: [CharacterPickerTableViewCellDataSource]? = nil
        var isHiddenEmptyView: Bool = true
        var isHiddenInvalidView: Bool = true
        var isDismiss: Bool = false
        var isEnabledConfirmButton: Bool = false
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
                        let dataSource = list.map { $0.toPresenter() }
                        return Mutation.setCharacterList(list: dataSource)
                        
                    case .empty:
                        return Mutation.setEmptyList(isEmpty: true)
                        
                    case .invalid:
                        return Mutation.setInvalidList(isInvalid: true)
                    }
                }
            
        case .confirmButtonTap:
            self.sendSelectedModels()
            return .just(.setDismiss(isDismiss: true))
            
        case .modifyCharacterButtonTap:
            self.presentModifyCharacterVC()
            return .just(.setDismiss(isDismiss: true))
            
        case .modelSelected(let model):
            guard let characterList = currentState.characterList else {
                return .never()
            }
            
            let list = characterList
                .map { dataSource in
                    var new = dataSource
                    
                    if dataSource.id == model.id {
                        new.isSelected.toggle()
                    }
                    
                    return new
                }
            
            let isEnabled = !list.map { $0.isSelected }.filter { $0 }.isEmpty
            
            return .concat(.just(.setCharacterList(list: list)),
                           .just(.setIsEnabledConfirmButton(isEnabled: isEnabled)))
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
            
        case .setDismiss(let isDismiss):
            newState.isDismiss = isDismiss
            return newState
            
        case .setIsEnabledConfirmButton(let isEnabled):
            newState.isEnabledConfirmButton = isEnabled
            return newState
        }
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
        new.isHiddenEmptyView = true
        new.isHiddenInvalidView = true
        
        return new
    }
    
    func sendSelectedModels() {
        guard let characterList = currentState.characterList else {
            return
        }
        
        let selectedModels = characterList.filter({ $0.isSelected })
        
        delegate?.selectedCharacters(selectedModels: selectedModels)
    }
    
    func presentModifyCharacterVC() {
        delegate?.presentModifyCharacterViewController()
    }
}
