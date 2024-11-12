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
        case setSelectedUrls(urls: [URL])
    }
    
    // 뷰에 전달할 상태
    struct State {
        var list: [CreateToonCompleteToonCollectionViewCellDataSource]? = nil
        var selectedUrls: [URL] = []
    }
    
    // 전달할 상태의 초기값
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            
            //            let list = urls
            //                .compactMap { URL(string: $0)}
            //                .map { url in
            //                CreateToonCompleteToonCollectionViewCellDataSource(
            //                    isSelected: false,
            //                    imageUrl: url)
            //                }
            
            let urls = [
               URL(string: "https://i.namu.wiki/i/cJ4OdJ2xZVY209TzWaXnY5ixXGmqrHGAH0DCBtHk4yEFkVxnzKHVV-c4e7qGHwvkACv_IA3dVaHVC0UhHoKZ8w.webp")!,
               URL(string: "https://i.namu.wiki/i/R0AhIJhQ3FZ6UPf_o6jw6UgL4j8_SkEWpXZFYDILk2ZwqwbQ7p_LjBNOVUYvtj-KoVrIiHQGrcyXwD0sO49HSQ.webp")!,
               URL(string: "https://i.namu.wiki/i/YS17q_BqP0ZvgeCYwD3uFeghHHDX_mwQzTgb5JHZGd8hiJr70WFLAr3i6DFRYk_-LIFf7KU4PCvkqQZQi3M4KQ.webp")!,
               URL(string: "https://i.namu.wiki/i/PE6CZGb_dqZwqhxGAO2CKg-a3G7BDA4bYgXzgF7L0OzrG_pxo7yAjx1u3yQKEwhE7xZMhiL43vHtVzCSuJgQiA.webp")!,
               URL(string: "https://i.namu.wiki/i/mQNc8LS1ABA0c_b80qEK8vhgw9wFeYixZTZwTF_5BJE1EleFGccK8DHvD0kVVIm8zSkGOsG2RfM7mOF7M1pwxw.webp")!,
               URL(string: "https://i.namu.wiki/i/M_VYdXYcq0-1c_JaHTpdizH4-G6a2AOKkngqIHm5_Ry6QJV0tCLnqprojection7eXqDM2Kv-dEMRGOY_CCd0N9Fw.webp")!,
               URL(string: "https://i.namu.wiki/i/UlQzHI0RP-2aI7XxK_yqtIKqV8b6S9VHdvUUUc2PxAqxKuXHF5iHHZsknBO1HcEKFRZ6kcZlRGR6UEyxv9U4RA.webp")!,
               URL(string: "https://i.namu.wiki/i/gYtcojoGUZK0KRHbVFKvwX3dzhIXqwH5Y9HSgwEEWwkBhvmB_kaCPSNyGVfFHsLFvPEPKgR-G9YCOjdxjuSa_A.webp")!,
               URL(string: "https://i.namu.wiki/i/HGVQYs6GpHNDIZgz_Fems8oR2duz1bqQQZm_AUMvD9IxS7WtKj3BNqEGqwj2ZBDtA7VtA7JQeO3D-oi3U9wD5g.webp")!,
               URL(string: "https://i.namu.wiki/i/PYNpxKxXImqfOKn7a1qEEZb7vtqE1TDJ4mQHk8GhEoTteo9eFvK5hiJ1S3eFwUjhoGR2AxRP15mecESbiYKnUg.webp")!,
               URL(string: "https://i.namu.wiki/i/OqH5oll3L4F0HQr-ajy5ngjE-j_gxE7E_mmWChKPRjxGBbP5okHraEHn8jrEH2T9gqnQhKxY4I1tr7SwLXnZ6w.webp")!,
               URL(string: "https://i.namu.wiki/i/2xXV88StFeT6v51jH09wBE1QRzwf1X_Ur0ZBpPK3S0rUXbE7ZpRw9_ahe5n7_JydHhEegpTzq0_EgFnBVZBEpw.webp")!
            ]

            let list = urls.map { url in
               CreateToonCompleteToonCollectionViewCellDataSource(isSelected: false, imageUrl: url)
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
            
            return .concat([
                .just(.setSelectedUrls(urls: selectedUrls)),
                .just(.setList(newList))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var new = state
        
        switch  mutation {
        case.setList(let list):
            new.list = list
            
        case.setSelectedUrls(let urls):
            new.selectedUrls = urls
        }
        
        return new
    }
}
