//
//  SaveToonReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 11/13/24.
//

import Foundation

import ReactorKit

final class SaveToonReactor: Reactor {
    let urls: [String]
    
    init(urls: [String]) {
        self.urls = urls
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewDidLoad
        //        case confirmButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setList([CreateToonCompleteToonCollectionViewCellDataSource])
        //        case setConfirmButtonTap(urls: [URL])
    }
    
    // 뷰에 전달할 상태
    struct State {
        var list: [CreateToonCompleteToonCollectionViewCellDataSource]? = nil
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let list = urls
                .compactMap { URL(string: $0)}
                .map { url in
                    CreateToonCompleteToonCollectionViewCellDataSource(
                        isSelected: false,
                        imageUrl: url)
                }
            
            return .just(.setList(list))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = state
        
        switch  mutation {
        case.setList(let list):
            new.list = list
        }
        
        return new
    }
}
