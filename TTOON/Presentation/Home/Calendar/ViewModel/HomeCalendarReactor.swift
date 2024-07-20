//
//  HomeCalendarReactor.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import Foundation
import ReactorKit

class HomeCalendarReactor: Reactor {
    init() {
        self.initialState = State(
            currentDate: Date(),
            currentYearMonth: Date().toString(of: .yearMonthKorean)
        )
    }
    
    enum Action {
        case didSelectCalendarCell(Date) // 캘린더 셀 클릭
    }
    
    enum Mutation {
        case setCurrentDate(Date)
    }
    
    struct State {
        var currentDate: Date
        var currentYearMonth: String // 편의를 위해 "yyyy년 M월" 포맷 String으로 저장
        
//        var diaryDetailData: // 구조체 만들기 (Entity)
    }
    
    let initialState: State
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSelectCalendarCell(let date):
            print("캘린더 셀 클릭 : \(date)")
            // TODO: diaryView에 들어갈 데이터 로드
            return .just(.setCurrentDate(date))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCurrentDate(let date):
            print("currentDate 변경 : \(date)")
            newState.currentDate = date
        }
        
        return newState
    }
}
