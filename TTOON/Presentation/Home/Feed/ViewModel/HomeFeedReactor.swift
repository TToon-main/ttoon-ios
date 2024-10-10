//
//  HomeFeedReactor.swift
//  TTOON
//
//  Created by 임승섭 on 10/6/24.
//

import Foundation
import ReactorKit


// 내 피드만 보기 선택 여부는 UserDefaults에 저장 후 앱 재시작할 때 활용하기

class HomeFeedReactor: Reactor {
    var didSendEventClosure: ((HomeFeedReactor.Event) -> Void)?
    
    private let homeFeedUseCase: HomeFeedUseCaseProtocol
    
    init(homeFeedUseCase: HomeFeedUseCaseProtocol) {
        self.homeFeedUseCase = homeFeedUseCase
    }
    
    enum Action {
        case loadFirstData(Bool)
        // Input
        // - 맨 처음 화면에 들어온 경우. (이 때는 UserDefaults에 저장된 bool 값 활용)
        // - switch를 누른 경우
        // Output
        // - feed list 초기화, pagination 초기화, 새롭게 네트워크 요청
        // - switch 값 재설정
        
        
        case loadNextFeedList
        // - pagination 진행. 현재 onlyMeFeed 값에 따라 네트워크 통신
        
        case likeButtonTapped(feedId: Int)  // add - true, delete - false
    }
    
    enum Mutation {
        case setOnlyMyFeedSwitch(Bool)
        case setFeedList([FeedWithInfoModel], Int)  // 리스트, page
        case setIsDone(Bool)
        case pass
    }
    
    struct State {
        var feedList: [FeedWithInfoModel] = []
        var page: Int = 0
        var onlyMyFeed: Bool = UserDefaultsManager.onlyMyFeed
        var isDone: Bool = false    // 빈 배열을 로드하면 true. 배열에 값이 있으면 false
    }
    
    let initialState = State()
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadFirstData(let onlyMine):            
            return homeFeedUseCase.getFeedList(onlyMine: onlyMine, page: 0)
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let newList):
                        if newList.isEmpty { return .setIsDone(true)}
                        return .setFeedList(newList, 1)

                    case .failure(let error):
                        return .pass
                    }
                }
            
        case .loadNextFeedList:
            if currentState.isDone { return .just(.pass) }
            
            let onlyMine = currentState.onlyMyFeed
            let currentPage = currentState.page
            return homeFeedUseCase.getFeedList(onlyMine: onlyMine, page: currentPage)
                .asObservable()
                .map { result in
                    switch result {
                    case .success(let arr):
                        if arr.isEmpty { return .setIsDone(true) }
                        
                        let newList = self.currentState.feedList + arr
                        return .setFeedList(newList, currentPage + 1)

                    case .failure(let error):
                        return .pass
                    }
                }
            
        case .likeButtonTapped(let feedId):
            // 해당 피드에 대한 내 좋아요 여부
            let isLike = isLikeOrNot(feedId: feedId)
            
            if !isLike {
                return homeFeedUseCase.addLikeToFeed(feedId: feedId)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success:
                            let newList = self.feedListAfterToggleLike(feedId: feedId)
                            let page = self.currentState.page
                            print("--- newList ---")
                            print(newList)
                            return .setFeedList(newList, page)

                        case .failure:
                            return .pass
                        }
                    }
            } else {
                return homeFeedUseCase.deleteLikeToFeed(feedId: feedId)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success:
                            let newList = self.feedListAfterToggleLike(feedId: feedId)
                            let page = self.currentState.page
                            print("--- newList ---")
                            print(newList)
                            return .setFeedList(newList, page)

                        case .failure:
                            return .pass
                        }
                    }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setOnlyMyFeedSwitch(let value):
            newState.onlyMyFeed = value

        case .setFeedList(let newList, let page):
            newState.feedList = newList
            newState.page = page

            
        case .setIsDone(let value):
            print("------ isDone : \(value)")
            newState.isDone = value

        case .pass:
            print("pass")
        }
        
        return newState
    }
}

extension HomeFeedReactor {
    enum Event {
        case showFriendListView
    }
}

extension HomeFeedReactor {
    // MARK: - 좋아요 기능
    // 좋아요 버튼 클릭 시,
    // 1. 좋아요 네트워크 콜 요청
    // 2. 응답 성공 시, reactor에 저장된 feed 배열의 값을 수정한다.
    // (즉, 네트워크 콜을 또 해서 피드 리스트를 받는 게 아니라, 로컬에 저장된 값만 수정한다)
    
    // 해당 피드에 대한 내 좋아요 여부
    private func isLikeOrNot(feedId: Int) -> Bool {
        let feedList = currentState.feedList
        return feedList.first { $0.id == feedId }?.likeOrNot ?? false
    }
    
    // 해당 피드의 좋아요 값 수정
    private func feedListAfterToggleLike(feedId: Int) -> [FeedWithInfoModel] {
        var feedList = currentState.feedList
        if let idx = feedList.firstIndex(where: { $0.id == feedId }) {
            if feedList[idx].likeOrNot {
                // false로 수정, 좋아요 -1
                feedList[idx].likeOrNot = false
                feedList[idx].likes -= 1
            } else {
                // true로 수정, 좋아요 +1
                feedList[idx].likeOrNot = true
                feedList[idx].likes += 1
            }
        }
        return feedList
    }
    
    
    
    // 해당 피드가 내 피드인지 확인하는 로직
    
    
}

/*
extension HomeFeedReactor {
    func makeMockData() -> [FeedModel] {
        let diaryTitles: [String] = [
            "오늘도 평화로운 하루",
            "비 오는 날의 산책",
            "우연히 마주친 옛 친구",
            "따뜻한 커피 한 잔",
            "뜻밖의 행운이 찾아오다",
            "작은 행복을 느낀 순간",
            "하루 종일 바빴던 날",
            "편안한 집에서의 휴식",
            "새로운 도전에 대한 기대",
            "작은 실수, 큰 배움",
            "느리게 흐르는 시간",
            "가을 향기 가득한 거리",
            "오랜만에 읽은 책",
            "친구와의 깊은 대화",
            "한적한 카페에서의 오후",
            "생각지도 못한 선물",
            "반려동물과의 소중한 시간",
            "별이 빛나는 밤하늘",
            "아름다운 풍경 속에서",
            "따뜻한 사람들과 함께한 저녁",
            "오늘도 감사한 하루",
            "달콤한 디저트와 함께한 오후",
            "새로운 취미를 시작하다",
            "꿈에 그리던 여행 준비",
            "잊지 못할 추억이 된 날",
            "생각보다 괜찮았던 하루",
            "작은 목표를 이룬 기쁨",
            "혼자만의 시간을 만끽하다",
            "나 자신을 위한 투자",
            "아무것도 하지 않은 휴식의 날"
        ]
        
        let diaryContents: [String] = [
            "오늘도 고마운 하루.",
            "아침에 마신 커피가 유난히 맛있었다. 따뜻한 커피 한 잔이 주는 여유가 이렇게 소중할 줄이야.",
            """
            "오랜만에 친구와 만났다. 바쁜 일상 속에서 잊고 지냈던 친구를 만나 이야기를 나누니 마음이 편안해졌다. 이런 시간이 더 많았으면 좋겠다는 생각이 든다.
            """,
            """
            오늘은 뜻밖의 비가 내렸다. 급하게 우산을 사서 집에 돌아왔지만, 빗속을 걷는 그 순간이 나쁘지 않았다.
            비가 주는 차분한 느낌이 마음을 어루만져주었고, 어느새 복잡했던 생각들이 사라졌다. 비오는 날의 매력은 역시 그 특별한 고요함에 있는 것 같다.
            """,
            """
            "새로운 취미로 사진을 시작해보았다. 평소에 흥미가 있었지만 쉽게 도전하지 못했던 분야인데, 막상 시작하고 나니 생각보다 더 재미있다.
            오늘은 카메라를 들고 공원으로 나가 가을 풍경을 찍었다. 사진 속에 담긴 나뭇잎의 색이 너무 아름다워서 나도 모르게 감탄했다.
            앞으로도 이 취미를 계속해보고 싶다.
            """,
            """
            바쁜 하루였다. 아침부터 저녁까지 일정이 빡빡해서 제대로 쉬지 못했지만, 그래도 할 일을 모두 마쳤다는 생각에 뿌듯함이 느껴졌다.
            이런 날들이 계속되면 몸이 힘들겠지만, 한편으로는 나 자신에게도 많은 자극이 되는 것 같다.
            오늘 하루는 열심히 달려온 나에게 작은 보상을 주고 싶은 마음이다.
            """,
            """
            오늘은 특별한 계획 없이 그냥 집에서 하루를 보냈다. 아침에는 늦잠을 자고, 점심때는 좋아하는 영화를 보며 소파에 누워있었다.
            별다른 일을 하지 않았지만, 이 여유로운 시간이 오히려 큰 힐링이 되었다. 오랜만에 나를 위한 시간을 보내니 마음도 편안해졌다.
            내일은 조금 더 부지런히 움직일 수 있을 것 같다.
            """,
            """
            "가을의 정취를 제대로 느낀 하루였다. 오후에 공원을 산책했는데, 나무에서 떨어지는 단풍잎들이 거리를 아름답게 수놓고 있었다.
            가을은 역시 이 색깔들이 주는 감동이 큰 것 같다. 발끝에서 바스락거리는 소리마저도 기분을 좋게 만들어 주었다.
            집으로 돌아오는 길에 따뜻한 커피를 한 잔 사서, 이 기분을 조금 더 오래 느끼고 싶었다.
            """,
            """
            비 오는 날, 창 밖을 보며 이런저런 생각에 잠겼다. 빗소리가 유난히 크게 들려서 그런지, 마음이 차분해졌다.
            최근 바쁜 일들로 인해 마음이 복잡했는데, 오늘은 잠시 멈춰서 나 자신을 돌아볼 수 있는 시간이 되었다.
            비가 주는 고요함 속에서 내 안의 불안함도 조금씩 사라지는 듯한 기분이 들었다. 앞으로는 더 자주 이런 여유를 가져야겠다.
            """,
            """
            오늘은 정말로 뜻깊은 날이었다. 오랜 시간 준비했던 프로젝트가 드디어 결실을 맺었다. 그동안 힘들었던 순간들도 많았지만,
            오늘의 결과를 보니 모든 노력이 헛되지 않았음을 느낄 수 있었다. 함께 고생한 팀원들과도 기쁨을 나눌 수 있어서 더욱 뜻깊었다.
            이런 순간들이 쌓여 나의 성장에 큰 도움이 되는 것 같다. 앞으로도 포기하지 않고 나아가야겠다.
            """,
            """
            친구들과 함께한 하루가 너무 즐거웠다. 오랜만에 만나서 서로의 안부를 묻고, 사소한 이야기들로 웃을 수 있었다.
            일상에 지친 마음도 친구들과 함께 있으니 한결 가벼워지는 기분이었다. 이런 소소한 순간들이 삶의 큰 행복이라는 것을 다시 한 번 느꼈다.
            함께할 수 있는 사람들이 있다는 것에 감사한 하루였다.
            """,
            """
            오늘은 오랜만에 운동을 했다. 운동을 안 한 지 꽤 오래돼서 걱정했지만, 막상 해보니 몸이 기억하는 것 같았다.
            뛰고 나니 기분도 상쾌하고, 땀을 흘리니 몸이 개운해졌다. 앞으로는 꾸준히 운동을 해야겠다는 다짐을 했다.
            건강을 위한 작은 노력들이 쌓이면 분명 큰 변화를 가져다줄 것이다.
            """,
            """
            저녁에 하늘을 올려다보니 별이 가득했다. 도시에서는 잘 볼 수 없는 풍경이었는데, 오늘은 운이 좋았던 것 같다.
            별빛을 보며 잠시 소원을 빌었다. 이런 순간들이 내 일상 속에서 작은 힐링이 되는 것 같다.
            복잡한 생각도 정리되고, 마음이 한결 가벼워졌다.
            """,
            """
            오늘은 나를 위한 하루로 정했다. 아침에는 책을 읽고, 점심에는 맛있는 음식을 먹으며 여유로운 시간을 보냈다.
            최근 바쁜 일정 속에서 나 자신을 돌보지 못한 것 같아서, 오늘만큼은 나를 위해 시간을 보냈다.
            이렇게 하루를 보내니 다시 에너지가 충전되는 기분이다. 가끔은 이런 여유가 필요하다.
            """,
            """
            오늘은 비록 작은 일이었지만, 큰 배움을 얻었다. 실수도 있었고, 예상치 못한 문제가 생기기도 했지만,그 모든 과정에서 많은 것을 배웠다.
            실패를 두려워하지 않고 도전하는 것이 얼마나 중요한지 다시 한 번 느꼈다. 앞으로는 더 용감하게, 더 적극적으로 도전해야겠다.
            성공의 길은 그 끝이 아니라 과정에 있음을 잊지 말아야겠다.
            """
        ]
        
        let diaryDates: [String] = [
            "2025-06-22",
            "2020-01-07",
            "2024-10-11",
            "2021-03-19",
            "2025-07-10",
            "2023-08-28",
            "2025-09-25",
            "2024-06-09",
            "2022-10-09",
            "2022-11-02",
            "2022-11-02",
            "2025-06-16",
            "2022-05-20",
            "2022-10-25",
            "2023-08-13",
            "2021-05-27",
            "2022-07-06",
            "2025-06-07",
            "2025-02-16",
            "2022-08-11"
        ]
        
        
        
        var arr: [FeedModel] = []
        
        
        for i in 1...20 {
            let m = FeedModel(
                id: i,
                title: diaryTitles.randomElement()!,
                imageList: [],
                content: diaryContents.randomElement()!,
                createdDate: diaryDates.randomElement()!,
                likes: Int.random(in: 0...100)
            )
            arr.append(m)
        }
        
        return arr
    }
}
*/
