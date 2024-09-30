//
//  HomeCalendarReactor.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import Foundation
import ReactorKit

class HomeCalendarReactor: Reactor {
    var didSendEventClosure: ((HomeCalendarReactor.Event) -> Void)?
    
    private let homeCalendarUseCase: HomeCalendarUseCaseProtocol
    
    init(_ useCase: HomeCalendarUseCaseProtocol) {
        self.homeCalendarUseCase = useCase
    }
    
    enum Action {
        case friendListButtonTapped  // 친구 추가하기 아이콘 클릭 => 화면 전환
        
        case loadFeedDetail(Date)   // bottom View에 일기 상세 정보 로드
        // Input
        // - 맨 처음
        // - 셀 클릭했을 때
        // - 연월 변경했을 때
        // Output
        // - currentDate 변경
        // - 네트워크 통신
        
        case loadCalendarThumbnails(String)
        // Input
        // - 맨 처음
        // - 연월 변경했을 때
        // - 맨 처음. 오늘 날짜로 로드
        // Output
        // - currentYearMonth 변경
        // - 네트워크 통신
        

        // 툰 디테일 메뉴 버튼
        case saveTToonImage(SaveImageType)
        case shareTToonImage(SaveImageType)
        case deleteTToon
    }
    
    enum Mutation {
        case pass   // 친구 추가하기 버튼의 경우, 추가적으로 처리할 일은 없다.
        case setCurrentDate(Date)
        case setCurrentYearMonth(String)
        
        case setCurrentCalendarThumbnails([FeedThumbnailModel])
        case setCurrentFeedDetail(FeedModel?)   // nil이면 기본 이미지를 보여준다.
    }
    
    struct State {
        var currentDate: Date = Date()           // 캘린더 셀에서 선택된 날짜
        var currentYearMonth: String = ""    // 연월 선택에서 선택된 연월 DateFormat : .yearMonthKorean ("yyyy년 M월")
        
        var currentThumbnails: [FeedThumbnailModel] = [] // 캘린더 썸네일 배열
        var currentFeedDetail: FeedModel?   // 데이터가 없으면 nil 저장
    }
    
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .friendListButtonTapped:
            didSendEventClosure?(.showFriendListView)
            return .just(.pass)
            
        case .loadFeedDetail(let date):
            // Network
            // - feedDetail
            return .concat([
                .just(.setCurrentDate(date)),

                homeCalendarUseCase.getFeedDetail(date.toString(of: .fullWithHyphen))
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let model):
                            return .setCurrentFeedDetail(model)

                        case .failure(let error):
                            // 데이터가 없거나, 네트워크 에러이면 NoDataView (일단)
                            return .setCurrentFeedDetail(nil)
                        }
                    }
            ])
            
        case .loadCalendarThumbnails(let yearMonth):
            // Network
            // - calendarThumbnail
            
            // 주의. 여기서 feedDetail을 로드하진 않는다.
            // 연월 바꾸는 곳에서, 0월 1일 형식으로 loadFeedDetail도 콜 때림
            // 즉, 여기서 CurrentDate를 건들지 않고, 무조건 썸네일 배열만 관리
            
            return .concat([
                homeCalendarUseCase.getCalendarThumbnails(yearMonth.toDate(to: .yearMonthKorean)!.toString(of: .yearMonthWithHyphen))
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let newList):
//                            print("new List : \(newList)")
                            return .setCurrentCalendarThumbnails(newList)
                            
                        case .failure(let error):
                            print("Thumbnail load 에러 : \(error)")
                            return .pass
                        }
                    },
                .just(.setCurrentYearMonth(yearMonth))
            ])
            
        // 툰 디테일 메뉴 버튼
        case .saveTToonImage(let type):
            
            if let model = currentState.currentFeedDetail {
                print("save button : \(type)")
                
                MakeImageViewManager.shared.saveImage(
                    imageUrls: model.imageList,
                    type: type
                )
            }
   
            return .just(.pass)
            
        case .shareTToonImage(let type):
            
            if let model = currentState.currentFeedDetail {
                print("share button : \(type)")
                
                MakeImageViewManager.shared.shareImage(
                    imageUrls: model.imageList,
                    type: type
                )
            }
            
            
            return .just(.pass)
            
        case .deleteTToon:
            print("delete button")
            return .just(.pass)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .pass:
            break
            
        case .setCurrentDate(let date):
            newState.currentDate = date
            
        case .setCurrentYearMonth(let yearMonth):
            newState.currentYearMonth = yearMonth
            
        case .setCurrentFeedDetail(let model):
            newState.currentFeedDetail = model
            
        case .setCurrentCalendarThumbnails(let newList):
            newState.currentThumbnails = newList
        }
        
        return newState
    }
}


extension HomeCalendarReactor {
    enum Event {
        case showFriendListView
    }
}

enum SaveImageType {
    case onePage    // 한 장에 4개
    case fourPage   // 4장 저장
}
