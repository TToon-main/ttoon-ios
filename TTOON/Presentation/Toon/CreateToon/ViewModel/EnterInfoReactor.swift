//
//  EnterInfoReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import ReactorKit
import RxSwift

final class EnterInfoReactor: Reactor {    
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
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textFieldDidChange(let text):
            return .just(.setTextFieldText(text))
            
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
        var newState = state
        
        switch mutation {
        case .setViewLifeCycle(let cycle):
            if cycle == .viewWillAppear {
                newState.presentCreateLoadingVC = nil
                newState.presentModifyCharacterVC = nil
                newState.presentCharacterPickerBS = nil   
            }
            
        case .setTextFieldText(let text):
            newState.validTextFieldText = text
            
        case .setSelectCharactersButtonTap:
            newState.presentCharacterPickerBS = ()
            
        case .setPresentModifyCharacterVC:
            newState.presentCharacterPickerBS = nil
            newState.presentModifyCharacterVC = ()
            
        case .setConfirmButtonTap:
            newState.presentCreateLoadingVC = ()
        }
        
        return newState
    }
}
