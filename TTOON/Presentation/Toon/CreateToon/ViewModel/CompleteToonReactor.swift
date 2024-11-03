//
//  CompleteToonReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//

import Foundation

import ReactorKit

final class CompleteToonReactor: Reactor {    
    let urls: [String]
    
    init(urls: [String]) {
        self.urls = urls
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewDidLoad
        case selectedIndex(Int)
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setList([CreateToonCompleteToonCollectionViewCellDataSource])
        case setCurrentOrder(order: CompleteToonSelectOrderType)
        case setSelectedImage(url: URL)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var currentOrder: CompleteToonSelectOrderType = .first
        var list: [CreateToonCompleteToonCollectionViewCellDataSource]? = nil
        var selectedImageUrl: URL? = nil
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
            
        case .selectedIndex(let index):
            guard let url = currentState.list?[index].imageUrl else {
                return .never()
            }
            
            var new = currentState.list.map { list in
                var newList = list
                newList[index].isSelected.toggle()
                return newList
            }
                
            
            
            return .concat([.just(.setSelectedImage(url: url)),
                            .just(.setList(new ?? []))
                           ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = state
        
        switch  mutation {
        case .setCurrentOrder(let order):
            new.currentOrder = order
            
        case.setList(let list):
            new.list = list
            
        case .setSelectedImage(let url):
            new.selectedImageUrl = url
        }
        
        return new
    }
}
