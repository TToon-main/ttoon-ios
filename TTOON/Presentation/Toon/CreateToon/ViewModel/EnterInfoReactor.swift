//
//  EnterInfoReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import ReactorKit
import RxSwift

final class EnterInfoReactor: Reactor {
    let useCase: ToonUseCaseProtocol
    
    struct CurrentProgress {
        var isSelectedCharacter: Bool
        var isTitleEntered: Bool
        var isDairyEntered: Bool
        
        func value() -> Float {
            let items = [isSelectedCharacter, isTitleEntered, isDairyEntered]
            let value = Float(items.filter({ $0 }).count) / Float(items.count)
            return max(value, 0.05)
        }
        
        func isAllValid() -> Bool {
            return isSelectedCharacter && isTitleEntered && isDairyEntered
        }
        
        init() {
            self.isSelectedCharacter = false
            self.isTitleEntered = false
            self.isDairyEntered = false
        }
    }
    
    var progress = CurrentProgress()
    
    init(useCase: ToonUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case dairyTextViewDidChange(String)
        case titleTextFieldTextDidChange(String)
        case selectCharactersButtonTap
        case presentModifyCharacterVC
        case characterSelected(models: [CharacterPickerTableViewCellDataSource])
        case confirmButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setDairyTextViewError(error: String?)
        case setTitleTextFieldError(error: String?)
        case setDairyTextViewTextCount(cnt: String)
        case setTitleTextFieldTextCount(cnt: String)
        case setProgressBar(CurrentProgress)
        case setSelectCharactersButtonTap
        case setPresentModifyCharacterVC
        case setCharacterButtonText(text: String)
        case setSelectedCharacterModels(models: [CharacterPickerTableViewCellDataSource])
        case setConfirmButtonTap
        case setTitleText(text: String)
        case setContentText(text: String)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var dairyTextViewError: String? = nil
        var titleTextFieldError: String? = nil
        var dairyTextViewTextCount: String = "0"
        var titleTextFieldTextCount: String = "0"
        var presentCharacterPickerBS: Void? = nil
        var presentModifyCharacterVC: Void? = nil
        var presentCreateLoadingVC: Void? = nil
        var currentProgress: Float = 0.05
        var characterButtonText: String? = nil
        var selectedCharacterModels: [CharacterPickerTableViewCellDataSource]? = nil
        var isEnabledConfirmButton = false
        var titleText: String = ""
        var contentText: String = ""
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dairyTextViewDidChange(let text):
            progress.isDairyEntered = !text.isEmpty &&  text.count <= 200
            
            let isError = text.count > 200
            let error: String? = isError ? "200자 내로 입력해주세요" : nil
            
            let mutation: Observable<Mutation> = .concat([
                .just(.setDairyTextViewError(error: error)),
                .just(.setDairyTextViewTextCount(cnt: "\(text.count)")),
                .just(.setProgressBar(progress)),
                .just(.setContentText(text: text))
            ])
            
            return mutation
            
        case .titleTextFieldTextDidChange(let text):
            progress.isTitleEntered = !text.isEmpty &&  text.count <= 20
            
            let isError = text.count > 20
            let error: String? = isError ? "20자 내로 입력해주세요" : nil
            
            let mutation: Observable<Mutation> = .concat([
                .just(.setTitleTextFieldError(error: error)),
                .just(.setTitleTextFieldTextCount(cnt: "\(text.count)")),
                .just(.setProgressBar(progress)),
                .just(.setTitleText(text: text))
            ])
            
            return mutation
            
        case .selectCharactersButtonTap:
            return .just(.setSelectCharactersButtonTap)
            
        case .presentModifyCharacterVC:
            return .just(.setPresentModifyCharacterVC)
            
        case .confirmButtonTap:
            if let model = self.fetchCreateToonRequestModel()  {
                return self.useCase.createToon(model: model)
                    .map { _ in .setConfirmButtonTap }
            } else {
                return .never()
            }
            
        case .characterSelected(let models):
            let text = models.map { $0.name }.joined(separator: ", ")
            progress.isSelectedCharacter = !text.isEmpty
            
            let mutation: Observable<Mutation> = .concat([
                .just(.setCharacterButtonText(text: text)),
                .just(.setProgressBar(progress)),
                .just(.setSelectedCharacterModels(models: models))
            ])
            
            return mutation
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = fetchNewState(state: state)
        
        switch mutation {
        case .setProgressBar(let progress):
            new.currentProgress = progress.value()
            new.isEnabledConfirmButton = progress.isAllValid()
            return new
            
        case .setDairyTextViewError(let error):
            new.dairyTextViewError = error
            return new
            
        case .setDairyTextViewTextCount(let cnt):
            new.dairyTextViewTextCount = cnt
            return new
            
        case .setTitleTextFieldError(let error):
            new.titleTextFieldError = error
            return new
            
        case .setTitleTextFieldTextCount(let cnt):
            new.titleTextFieldTextCount = cnt
            return new
            
        case .setSelectCharactersButtonTap:
            new.presentCharacterPickerBS = ()
            return new
            
        case .setPresentModifyCharacterVC:
            new.presentModifyCharacterVC = ()
            return new
            
        case .setConfirmButtonTap:
            new.presentCreateLoadingVC = ()
            return new
            
        case .setCharacterButtonText(let text):
            new.characterButtonText = text
            return new
            
        case .setSelectedCharacterModels(let models):
            new.selectedCharacterModels = models
            return new
            
        case .setTitleText(let text):
            new.titleText = text
            return new
            
        case .setContentText(let text):
            new.contentText = text
            return new
        }
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
        new.presentCreateLoadingVC = nil
        new.presentModifyCharacterVC = nil
        new.presentCharacterPickerBS = nil
        
        return new
    }
    
    private func fetchCreateToonRequestModel() -> CreateToon?  {
        let state = currentState
        
        guard let selectedCharacterModels = state.selectedCharacterModels else {
            return nil
        }
        
        let mainCharacterId = selectedCharacterModels
            .filter { $0.isMainCharacter }
            .map { $0.id }
            .map { Int64($0)}
            .compactMap { $0 }
            .first

        let others = selectedCharacterModels
            .filter { !$0.isMainCharacter }
            .map { $0.id }
            .map { Int64($0) }
            .compactMap { $0 }
        
        let number = selectedCharacterModels.count
        
        let title = state.titleText
        
        let content = state.contentText
        
        return CreateToon(mainCharacterId: mainCharacterId ?? 0,
                          others: others,
                          number: number,
                          title: title,
                          content: content)
    }
}
