//
//  EnterInfoReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import ReactorKit
import RxSwift

final class EnterInfoReactor: Reactor {
    struct CurrentProgress {
        var isSelectedCharacter: Bool
        var isTitleEntered: Bool
        var isDairyEntered: Bool
        
        func value() -> Float {
            let items = [isSelectedCharacter, isTitleEntered, isDairyEntered]
            let value = Float(items.filter({ $0 }).count) / Float(items.count)
            return max(value, 0.05)
        }
        
        init() {
            self.isSelectedCharacter = false
            self.isTitleEntered = false
            self.isDairyEntered = false
        }
    }

    var progress = CurrentProgress()
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewLifeCycle(ViewLifeCycle)
        case textFieldDidChange(String)
        case selectCharactersButtonTap
        case presentModifyCharacterVC
        case confirmButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setViewLifeCycle(ViewLifeCycle)
        case setTextFieldText(String?)
        case setProgressBar(CurrentProgress)
        case setSelectCharactersButtonTap
        case setPresentModifyCharacterVC
        case setConfirmButtonTap
    }
    
    // 뷰에 전달할 상태
    struct State {
        var validTextFieldText: String? = nil
        var presentCharacterPickerBS: Void? = nil
        var presentModifyCharacterVC: Void? = nil 
        var presentCreateLoadingVC: Void? = nil
        var currentProgress: Float = 0.05
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textFieldDidChange(let text):
            progress.isDairyEntered = !text.isEmpty
            
            return .concat(.just(.setTextFieldText(text)),
                           .just(.setProgressBar(progress))
            )
            
        case .selectCharactersButtonTap:
            return .just(.setSelectCharactersButtonTap)
            
        case .presentModifyCharacterVC:
            return .just(.setPresentModifyCharacterVC)
            
        case .confirmButtonTap:
            return .just(.setConfirmButtonTap)
            
        case .viewLifeCycle(let cycle):
            return .just(.setViewLifeCycle(cycle))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setViewLifeCycle(let cycle):
            var new = state
            if cycle == .viewWillAppear {
                new.presentCreateLoadingVC = nil
                new.presentModifyCharacterVC = nil
                new.presentCharacterPickerBS = nil
            }
            return new
            
        case .setProgressBar(let progress):
            var new = state
            new.currentProgress = progress.value()
            return new

        case .setTextFieldText(let text):
            var new = state
            new.validTextFieldText = text
            return new

        case .setSelectCharactersButtonTap:
            var new = state
            new.presentCharacterPickerBS = ()
            return new

        case .setPresentModifyCharacterVC:
            var new = state
            new.presentCharacterPickerBS = nil
            new.presentModifyCharacterVC = ()
            return new
            
        case .setConfirmButtonTap:
            var new = state
            new.presentCreateLoadingVC = ()
            return new
        }
    }
}
