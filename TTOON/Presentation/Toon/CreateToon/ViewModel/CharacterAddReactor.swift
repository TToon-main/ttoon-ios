//
//  CharacterEditorReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import ReactorKit
import RxSwift

final class CharacterAddReactor: Reactor {
    struct IsEnabledConfirmButton {
        var isValidName: Bool = false
        var isValidInfo: Bool = false
        
        mutating func isEnabled() -> Bool {
            return isValidName && isValidInfo
        }
    }
    
    private var isEnabledConfirmButton = IsEnabledConfirmButton()
    
    private let useCase: ToonUseCaseProtocol
    
    init(useCase: ToonUseCase) {
        self.useCase = useCase
    }
    
    enum Action {
        case nameText(text: String)
        case infoText(text: String)
        case isMainCharacter(isMain: Bool)
        case confirmButtonTap(model: AddCharacter)
    }
    
    enum Mutation {
        case setNameTextFiledCountLabel(cnt: String)
        case setInfoTextFiledCountLabel(cnt: String)
        case setErrorNameTextFiled(error: String?)
        case setErrorInfoTextFiled(error: String?)
        case setIsOnSwitch(isOn: Bool)
        case setIsEnabledConfirmButton(isEnabled: Bool)
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
            
            isEnabledConfirmButton.isValidName = !isError && !text.isEmpty
            
            return .concat([.just(.setNameTextFiledCountLabel(cnt: "\(cnt)")),
                            .just(.setErrorNameTextFiled(error: errorMessage)),
                            .just(.setIsEnabledConfirmButton(isEnabled: isEnabledConfirmButton.isEnabled()))
                            ])

        case .infoText(let text):
            let cnt = text.count
            let isError = cnt >= 150
            let errorMessage: String? = isError ? "150자 내로 입력해주세요" : nil
            
            isEnabledConfirmButton.isValidInfo = !isError && !text.isEmpty
            
            return .concat([.just(.setInfoTextFiledCountLabel(cnt: "\(cnt)")),
                            .just(.setErrorInfoTextFiled(error: errorMessage)),
                            .just(.setIsEnabledConfirmButton(isEnabled: isEnabledConfirmButton.isEnabled()))
                            ])

        case .isMainCharacter(let isMain):
            return .just(.setIsOnSwitch(isOn: isMain))
            
        case .confirmButtonTap(model: let model):
            return useCase.addCharacter(model: model)
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
        }
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
        new.presentFailToast = false
        
        return new
    }
    
    func setIsMainCharacter(id: String) {
        UserDefaultsManager.mainCharacterId = id
    }
}
