//
//  CharacterEditReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/28/24.
//

import ReactorKit
import RxSwift

final class CharacterEditReactor: Reactor {
    private let model: ModifyCharacter
    private let useCase: ToonUseCaseProtocol
    
    struct IsEnabledConfirmButton {
        var isValidName: Bool = false
        var isValidInfo: Bool = false
        var isChangedText: Bool = false
        
        mutating func isEnabled() -> Bool {
            return isValidName && isValidInfo && isChangedText
        }
    }
    
    private var isEnabledConfirmButton = IsEnabledConfirmButton()
    
    init(model: ModifyCharacter, useCase: ToonUseCaseProtocol) {
        self.model = model
        self.useCase = useCase
    }
    
    enum Action {
        case setInitialData
        case nameText(text: String)
        case infoText(text: String)
        case isMainCharacter(isMain: Bool)
        case confirmButtonTap(model: AddCharacter)
        case deletedButtonTap
    }
    
    enum Mutation {
        case setNameTextFiledCountLabel(cnt: String)
        case setInfoTextFiledCountLabel(cnt: String)
        case setErrorNameTextFiled(error: String?)
        case setErrorInfoTextFiled(error: String?)
        case setIsOnSwitch(isOn: Bool)
        case setIsEnabledConfirmButton(isEnabled: Bool)
        case setNameText(String?)
        case setInfoText(String?)
        case setPop
        case setFailToast
    }
    
    struct State {
        var nameTextFiledCountLabel = "0"
        var infoTextFiledCountLabel = "0"
        var errorNameTextFiled: String? = nil
        var errorInfoTextFiled: String? = nil
        var isOn = false
        var isEnabledConfirmButton = false
        var nameText: String? = nil
        var infoText: String? = nil
        var pop = false
        var presentFailToast = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nameText(let text):
            let cnt = text.count
            let isError = cnt >= 10
            let errorMessage: String? = isError ? "10자 내로 입력해주세요" : nil

            let isSameText = text == model.name
            
            isEnabledConfirmButton.isValidName = !isError && !text.isEmpty
            isEnabledConfirmButton.isChangedText = !isSameText
            
            return .concat([.just(.setNameTextFiledCountLabel(cnt: "\(cnt)")),
                            .just(.setErrorNameTextFiled(error: errorMessage)),
                            .just(.setIsEnabledConfirmButton(isEnabled: isEnabledConfirmButton.isEnabled()))
            ])
            
        case .infoText(let text):
            let cnt = text.count
            let isError = cnt >= 150
            let errorMessage: String? = isError ? "150자 내로 입력해주세요" : nil
            
            let isSameText = text == model.info
            
            isEnabledConfirmButton.isValidInfo = !isError && !text.isEmpty
            isEnabledConfirmButton.isChangedText = !isSameText
            
            return .concat([.just(.setInfoTextFiledCountLabel(cnt: "\(cnt)")),
                            .just(.setErrorInfoTextFiled(error: errorMessage)),
                            .just(.setIsEnabledConfirmButton(isEnabled: isEnabledConfirmButton.isEnabled()))
            ])
            
        case .isMainCharacter(let isMain):
            return .just(.setIsOnSwitch(isOn: isMain))
            
        case .confirmButtonTap(let model):
            
            let id = self.model.id
            let name = model.name
            let info = model.info
            let model = ModifyCharacter(id: id, name: name, info: info)
            
            return useCase.patchCharacter(model: model)
                .map { result in
                    if let result = result {
                        if self.currentState.isOn {
                            self.setIsMainCharacter(id: "\(result)")
                        }
                        
                        return .setPop
                    } else {
                        return .setFailToast
                    }
                }
            
        case .setInitialData:
            let model = self.model
            return .concat(.just(.setNameText(model.name)),
                           .just(.setNameTextFiledCountLabel(cnt: "\(model.name.count)")),
                           .just(.setInfoText(model.info)),
                           .just(.setInfoTextFiledCountLabel(cnt: "\(model.info.count)")))

        case .deletedButtonTap:
            let id = self.model.id
            let model = DeleteCharacter(id: id, name: nil)
            
            return useCase.deleteCharacter(id: id)
                .map { result in
                    if result {
                        return .setPop
                    } else {
                        return .setFailToast
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = fetchNewState(state: state)
        
        switch mutation {
        case .setNameTextFiledCountLabel(let cnt):
            new.nameTextFiledCountLabel = cnt
            
            return new
            
        case .setInfoTextFiledCountLabel(let cnt):
            new.infoTextFiledCountLabel = cnt
            
            return new
            
        case .setErrorNameTextFiled(let error):
            new.errorNameTextFiled = error
            
            return new
            
        case .setErrorInfoTextFiled(let error):
            new.errorInfoTextFiled = error
            
            return new
            
        case .setIsOnSwitch(let isOn):
            new.isOn = isOn
            
            return new
            
        case .setIsEnabledConfirmButton(let isEnabled):
            new.isEnabledConfirmButton = isEnabled
            
            return new
            
        case .setPop:
            new.pop = true
            
            return new
            
        case .setFailToast:
            new.presentFailToast = true
            
            return new
            
        case .setInfoText(let info):
            new.infoText = info
            return new
            
        case .setNameText(let name):
            new.nameText = name
            return new
        }
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
        new.presentFailToast = false
        new.infoText = nil
        new.nameText = nil
        
        return new
    }
    
    func setIsMainCharacter(id: String) {
        UserDefaultsManager.mainCharacterId = id
    }
}
