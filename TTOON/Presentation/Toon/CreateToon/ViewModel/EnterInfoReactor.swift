//
//  EnterInfoReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import ReactorKit
import RxSwift

protocol CreateToonDelegate: AnyObject {
    func createToon(model: CreateToon)
}

final class EnterInfoReactor: Reactor {
    let useCase: ToonUseCaseProtocol
    
    weak var delegate: CreateToonDelegate?
    
    struct CurrentProgress {
        var isSelectedCharacter: Bool
        var isTitleEntered: Bool
        var isDairy1Entered: Bool
        var isDairy2Entered: Bool
        var isDairy3Entered: Bool
        var isDairy4Entered: Bool
        
        func value() -> Float {
            let items = [isSelectedCharacter, isTitleEntered, isDairy1Entered, isDairy2Entered, isDairy3Entered, isDairy4Entered]
            let value = Float(items.filter({ $0 }).count) / Float(items.count)
            return max(value, 0.05)
        }
        
        func isAllValid() -> Bool {
            return isSelectedCharacter && isTitleEntered && isDairy1Entered && isDairy2Entered && isDairy3Entered && isDairy4Entered
        }
        
        init() {
            self.isSelectedCharacter = false
            self.isTitleEntered = false
            self.isDairy1Entered = false
            self.isDairy2Entered = false
            self.isDairy3Entered = false
            self.isDairy4Entered = false
        }
    }
    
    var progress = CurrentProgress()
    
    init(useCase: ToonUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case dairyTextView1DidChange(String)
        case dairyTextView2DidChange(String)
        case dairyTextView3DidChange(String)
        case dairyTextView4DidChange(String)
        case titleTextFieldTextDidChange(String)
        case selectCharactersButtonTap
        case presentModifyCharacterVC
        case characterSelected(models: [CharacterPickerTableViewCellDataSource])
        case confirmButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setDairyTextView1Error(error: String?)
        case setDairyTextView2Error(error: String?)
        case setDairyTextView3Error(error: String?)
        case setDairyTextView4Error(error: String?)
        case setTitleTextFieldError(error: String?)
        case setDairyTextView1TextCount(cnt: String)
        case setDairyTextView2TextCount(cnt: String)
        case setDairyTextView3TextCount(cnt: String)
        case setDairyTextView4TextCount(cnt: String)
        case setTitleTextFieldTextCount(cnt: String)
        case setProgressBar(CurrentProgress)
        case setSelectCharactersButtonTap
        case setPresentModifyCharacterVC
        case setCharacterButtonText(text: String)
        case setSelectedCharacterModels(models: [CharacterPickerTableViewCellDataSource])
        case setConfirmButtonTap
        case setTitleText(text: String)
        case setContentText(text: String)
        case setPop
    }
    
    // 뷰에 전달할 상태
    struct State {
        var dairyTextView1Error: String? = nil
        var dairyTextView2Error: String? = nil
        var dairyTextView3Error: String? = nil
        var dairyTextView4Error: String? = nil
        var titleTextFieldError: String? = nil
        var dairyTextView1TextCount: String = "0"
        var dairyTextView2TextCount: String = "0"
        var dairyTextView3TextCount: String = "0"
        var dairyTextView4TextCount: String = "0"
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
        var presentEnterInfoCompleteVC: Bool = false
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .dairyTextView1DidChange(let text):
            progress.isDairy1Entered = !text.isEmpty &&  text.count <= 200
            
            let isError = text.count > 200
            let error: String? = isError ? "200자 내로 입력해주세요" : nil
            
            let mutation: Observable<Mutation> = .concat([
                .just(.setDairyTextView1Error(error: error)),
                .just(.setDairyTextView1TextCount(cnt: "\(text.count)")),
                .just(.setProgressBar(progress)),
                .just(.setContentText(text: text))
            ])
            
            return mutation
            
        case .dairyTextView2DidChange(let text):
            progress.isDairy2Entered = !text.isEmpty &&  text.count <= 150
            
            let isError = text.count > 150
            let error: String? = isError ? "200자 내로 입력해주세요" : nil
            
            let mutation: Observable<Mutation> = .concat([
                .just(.setDairyTextView2Error(error: error)),
                .just(.setDairyTextView2TextCount(cnt: "\(text.count)")),
                .just(.setProgressBar(progress)),
                .just(.setContentText(text: text))
            ])
            
            return mutation

        case .dairyTextView3DidChange(let text):
            progress.isDairy3Entered = !text.isEmpty &&  text.count <= 150
            
            let isError = text.count > 150
            let error: String? = isError ? "200자 내로 입력해주세요" : nil
            
            let mutation: Observable<Mutation> = .concat([
                .just(.setDairyTextView3Error(error: error)),
                .just(.setDairyTextView3TextCount(cnt: "\(text.count)")),
                .just(.setProgressBar(progress)),
                .just(.setContentText(text: text))
            ])
            
            return mutation

        case .dairyTextView4DidChange(let text):
            progress.isDairy4Entered = !text.isEmpty &&  text.count <= 150
            
            let isError = text.count > 150
            let error: String? = isError ? "200자 내로 입력해주세요" : nil
            
            let mutation: Observable<Mutation> = .concat([
                .just(.setDairyTextView4Error(error: error)),
                .just(.setDairyTextView4TextCount(cnt: "\(text.count)")),
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
                self.delegate?.createToon(model: model)
                return .just(.setPop)
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
            
        case .setDairyTextView1Error(let error):
            new.dairyTextView1Error = error
            return new
            
        case .setDairyTextView2Error(let error):
            new.dairyTextView2Error = error
            return new

        case .setDairyTextView3Error(let error):
            new.dairyTextView3Error = error
            return new

        case .setDairyTextView4Error(let error):
            new.dairyTextView4Error = error
            return new
            
        case .setDairyTextView1TextCount(let cnt):
            new.dairyTextView1TextCount = cnt
            return new

        case .setDairyTextView2TextCount(let cnt):
            new.dairyTextView2TextCount = cnt
            return new

        case .setDairyTextView3TextCount(let cnt):
            new.dairyTextView3TextCount = cnt
            return new

        case .setDairyTextView4TextCount(let cnt):
            new.dairyTextView4TextCount = cnt
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
            
        case .setPop:
            new.presentEnterInfoCompleteVC = true
            return new
        }
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
        new.presentCreateLoadingVC = nil
        new.presentModifyCharacterVC = nil
        new.presentCharacterPickerBS = nil
        new.presentEnterInfoCompleteVC = false
        
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
