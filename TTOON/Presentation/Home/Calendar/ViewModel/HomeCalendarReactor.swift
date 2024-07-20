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
        // 맨 처음은 현재 날짜.
        self.initialState = State(
            currentDate: Date(),
            currentYearMonth: Date().toString(of: .yearMonthKorean)
        )
    }
    
    enum Action {
        case didSelectCalendarCell(Date) // 캘린더 셀 클릭
        case selectYearMonth(String)  // 연월 수정
    }
    
    enum Mutation {
        case setCurrentDate(Date)
        case setCurrentYearMonth(String)
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
            // TODO: diaryView에 들어갈 데이터 로드 (네트워크 통신)
            return .just(.setCurrentDate(date))
            
        case .selectYearMonth(let yearMonth):
            // TODO: diaryView에 들어갈 데이터 로드 (네트워크 통신)
            
            // 매달 1일로 newDate 설정
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: yearMonth.toDate(to: .yearMonthKorean) ?? Date())
            components.day = 1 // 아마 출력은 2일이라고 뜨는데, 선택된 날짜 확인해보면 1일로 뜰 것
            
            let newDate = calendar.date(from: components)
            
            return .concat(
                .just(.setCurrentDate(newDate ?? Date())),
                .just(.setCurrentYearMonth(yearMonth))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCurrentDate(let date):
            print("(r) currentDate 변경 : \(date)")
            newState.currentDate = date
            
        case .setCurrentYearMonth(let yearMonth):
            print("(r) yearMonth 변경 : \(yearMonth)")
            newState.currentYearMonth = yearMonth
        }
        
        return newState
    }
}
