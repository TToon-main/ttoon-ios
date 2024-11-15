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
    private let toonUseCase: ToonUseCaseProtocol

    
    init(_ useCase: HomeCalendarUseCaseProtocol, toonUseCase: ToonUseCaseProtocol) {
        self.homeCalendarUseCase = useCase
        self.toonUseCase = toonUseCase
    }
    
    enum Action {
        case friendListButtonTapped  // 친구 추가하기 아이콘 클릭 => 화면 전환
        
        case loadFeedDetail(Date)   // bottom View에 일기 상세 정보 로드
        // - currentDate 변경
        // - 네트워크 통신
        
        case loadCalendarThumbnails(String)
        // Output
        // - currentYearMonth 변경
        // - 네트워크 통신
        

        // 툰 디테일 메뉴 버튼
        case saveTToonImage(SaveImageType)
        case shareTToonImage(SaveImageType)
        case deleteTToon
        
        
        // 웹툰 생성 페이지 이동 버튼
        case plusButtonTapped
        
        case createToon(CreateToon)
        
        case presentCreatingToast
        
        case completeToastTap(SaveToon)
    }
    
    enum Mutation {
        case setCurrentDate(Date)
        case setCurrentYearMonth(String)
        
        case setCurrentCalendarThumbnails([FeedThumbnailModel])
        case setCurrentFeedDetail(FeedModel?)   // nil이면 기본 이미지를 보여준다.
        
        case setLoadDataAgain   // 피드 삭제 후, 다시 데이터를 로드하라는 의미
        
        case setPresentCreateToonToast(CreateToonStatus) // 요청 상태에 따른 토스트
        
        case pass
    }
    
    struct State {
        var currentDate: Date = Date()           // 캘린더 셀에서 선택된 날짜
        var currentYearMonth: String = Date().toString(of: .yearMonthKorean)    // 연월 선택에서 선택된 연월 DateFormat : .yearMonthKorean ("yyyy년 M월")
        
        var currentThumbnails: [FeedThumbnailModel] = [] // 캘린더 썸네일 배열
        var currentFeedDetail: FeedModel?   // 데이터가 없으면 nil 저장
        
        var loadDataAgain: Bool = false     // "삭제하기"가 끝나면 다시 데이터를 로드하게 하기 위한 변수
        
        var presentCreateToonToast: CreateToonStatus = .idle
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
                    },
                .just(.setCurrentDate(date))
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
                            return .setCurrentCalendarThumbnails(newList)
                            
                        case .failure(let error):
                            return .pass
                        }
                    },
                .just(.setCurrentYearMonth(yearMonth))
            ])
            
        // 툰 디테일 메뉴 버튼
        case .saveTToonImage(let type): // 이미지 저장
            if let model = currentState.currentFeedDetail {
                MakeImageViewManager.shared.saveImage(
                    imageUrls: model.imageList,
                    type: type
                )
            }
            return .just(.pass)
            
        case .shareTToonImage(let type):    // 이미지 공유
            if let model = currentState.currentFeedDetail {
                MakeImageViewManager.shared.shareImage(
                    imageUrls: model.imageList,
                    type: type
                )
            }
            return .just(.pass)
            
        case .deleteTToon:
            guard let curFeedId = currentState.currentFeedDetail?.id else { return .just(.pass) }
            
            return homeCalendarUseCase.deleteFeed(curFeedId)
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let value):
                        if value { return .setLoadDataAgain }
                        else { return .pass }

                    case .failure(let error):
                        return .pass
                    }
                }
            
        case .plusButtonTapped:
            didSendEventClosure?(.showCreateToonView)
            return .just(.pass)
            
        case .createToon(let model):
        
            return toonUseCase.createToon(model: model)
                .map { status in
                    switch status {
                    case .valid(let saveToon):
                            .setPresentCreateToonToast(.complete(model: saveToon))

                    case .error:
                            .setPresentCreateToonToast(.idle)
                    }
                }
            
        case .presentCreatingToast:
            return .just(.setPresentCreateToonToast(.ing))
            
        case .completeToastTap(let model):
            didSendEventClosure?(.showCompleteCreateToonView(model: model))
            return .just(.pass)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = fetchNewState(state: state)
        
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
            
        case .setLoadDataAgain:
            let curValue = currentState.loadDataAgain
            newState.loadDataAgain = !curValue
            
        case .setPresentCreateToonToast(let status):
            newState.presentCreateToonToast = status
        }
        
        return newState
    }
    
    func fetchNewState(state: State) -> State {
        var new = state
            new.presentCreateToonToast = .idle
        
        return new
    }
}


extension HomeCalendarReactor {
    enum Event {
        case showFriendListView
        case showCreateToonView
        case showCompleteCreateToonView(model: SaveToon)
    }
}

enum SaveImageType {
    case onePage    // 한 장에 4개
    case fourPage   // 4장 저장
}

enum CreateToonStatus: Equatable {
    case idle
    case ing
    case complete(model: SaveToon)
}


extension HomeCalendarReactor: CreateToonDelegate {
    func createToon(model: CreateToon) {
        self.action.onNext(.createToon(model))
        self.action.onNext(.presentCreatingToast)
    }
}
