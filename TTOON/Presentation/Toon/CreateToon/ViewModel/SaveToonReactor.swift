//
//  SaveToonReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 11/13/24.
//

import Foundation

import ReactorKit

final class SaveToonReactor: Reactor {
    let model: SaveToon
    let useCase: ToonUseCaseProtocol
    
    init(model: SaveToon, useCase: ToonUseCaseProtocol) {
        self.model = model
        self.useCase = useCase
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewDidLoad
        case confirmButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setList([CreateToonCompleteToonCollectionViewCellDataSource])
        case setConfirmButtonTap(Bool)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var list: [CreateToonCompleteToonCollectionViewCellDataSource]? = nil
        var isSuccessSave: Bool = false
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let list = model.imageUrls
                .compactMap { $0 }
                .map { url in
                    CreateToonCompleteToonCollectionViewCellDataSource(
                        isSelected: false,
                        imageUrl: url)
                }
            
            return .just(.setList(list))
            
        case .confirmButtonTap:
            return useCase.saveToon(model: model)
                .map { .setConfirmButtonTap($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = state
        
        switch  mutation {
        case.setList(let list):
            new.list = list
            
        case.setConfirmButtonTap(let isSuccess):
            new.isSuccessSave = isSuccess
        }
        
        return new
    }
}
