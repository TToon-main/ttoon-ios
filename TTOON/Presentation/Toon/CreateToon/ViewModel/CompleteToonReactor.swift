//
//  CompleteToonReactor.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//

import Foundation

import ReactorKit

final class CompleteToonReactor: Reactor {
    let model: SaveToon
    
    init(model: SaveToon) {
        self.model = model
    }
    
    // 뷰에서 입력받은 유저 이벤트
    enum Action {
        case viewDidLoad
        case selectedIndex(Int)
        case confirmButtonTap
    }
    
    // Action과 State의 매개체
    enum Mutation {
        case setList([CreateToonCompleteToonCollectionViewCellDataSource])
        case setSelectedUrls(urls: [URL])
        case setConfirmButtonTap(model: SaveToon)
        case setProgressBar(Float)
    }
    
    // 뷰에 전달할 상태
    struct State {
        var list: [CreateToonCompleteToonCollectionViewCellDataSource]? = nil
        var selectedUrls: [URL] = []
        var isEnabledConfirmButton: Bool = false
        var presentSaveToonVC: SaveToon? = nil
        var currentProgress: Float = 0.05
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let list = model.imageUrls
                .map { url in
                    CreateToonCompleteToonCollectionViewCellDataSource(
                        isSelected: false,
                        imageUrl: url)
                }
            
            return .just(.setList(list))
            
        case .selectedIndex(let index):
            guard let list = currentState.list else {
                return .never()
            }
            
            var newList = list
            let url = newList[index].imageUrl
            var selectedUrls = currentState.selectedUrls
            
            // 이미 선택된 상태에서 다시 클릭한 경우
            if newList[index].isSelected {
                // 선택 해제
                newList[index].isSelected = false
                
                // selectedUrls에서 해당 URL의 인덱스를 찾아서 제거
                if let urlIndex = selectedUrls.firstIndex(of: url) {
                    selectedUrls.remove(at: urlIndex)
                }
            } else {
                // 새로운 이미지 선택
                if selectedUrls.count < 4 {
                    // 4개 미만이면 추가
                    selectedUrls.append(url)
                    newList[index].isSelected = true
                } else {
                    // 4개가 이미 선택된 경우
                    // 마지막에 선택된 이미지의 선택 해제
                    if let lastSelectedIndex = newList.firstIndex(where: { $0.imageUrl == selectedUrls.first }) {
                        newList[lastSelectedIndex].isSelected = false
                    }
                    
                    // 마지막 이미지 제거하고 새로운 이미지 추가
                    selectedUrls.removeFirst()
                    selectedUrls.append(url)
                    newList[index].isSelected = true
                }
            }
            
            let currentProgress = max(Float(selectedUrls.count) / 4.0, 0.05)
            
            return .concat([
                .just(.setSelectedUrls(urls: selectedUrls)),
                .just(.setList(newList)),
                .just(.setProgressBar(currentProgress))
            ])
            
        case .confirmButtonTap:
            let urls = currentState.selectedUrls
            let new = SaveToon(imageUrls: urls, feedId: self.model.feedId)
            
            return .just(.setConfirmButtonTap(model: new))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = fetchNewState(state: state)
        
        switch  mutation {
        case.setList(let list):
            new.list = list
            
        case.setSelectedUrls(let urls):
            new.selectedUrls = urls
            new.isEnabledConfirmButton = urls.count == 4
            
        case .setConfirmButtonTap(let urls):
            new.presentSaveToonVC = urls
            
        case .setProgressBar(let progress):
            new.currentProgress = progress
        }
        
        return new
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
        new.presentSaveToonVC = nil
        
        return new
    }
}
