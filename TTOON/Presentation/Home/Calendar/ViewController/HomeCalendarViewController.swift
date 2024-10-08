//
//  HomeCalendarViewController.swift
//  TTOON
//
//  Created by 임승섭 on 7/18/24.
//

import FSCalendar
import ReactorKit
import RxCocoa
import RxSwift
import UIKit


class HomeCalendarViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    
    // MARK: - UI Component (View)
    let mainView = HomeCalendarView()
    let ttoonNavigationView = TToonLogHomeNavigationView()
    
    
    init(reactor: HomeCalendarReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCustomNavigationBar(ttoonNavigationView)
        connectCalendar() // 캘린더
        connectCollectionView() // 스와이프 컬렉션뷰
        loadInitialData()
    }
}

// MARK: - ReactorKit bind
extension HomeCalendarViewController {
    func bind(reactor: HomeCalendarReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: HomeCalendarReactor) {
        // 네비게이션 버튼 눌렀을 때 액션 전달 -> reactor에서 화면 전환
        ttoonNavigationView.friendListButton.rx.tap
            .map {
                return HomeCalendarReactor.Action.friendListButtonTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 연월 변경 버튼 클릭 - 따로 reactor에 bind 없이 바텀 시트 띄우는 로직 (바텀시트 VC에 reactor 전달)
        mainView.calendarView.selectYearMonthView.clearButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.presentSelectYearMonthBottomSheetVC()
            }
            .disposed(by: disposeBag)
        
        // 피드 상세 메뉴 버튼 클릭 - 따로 reactor에 bind 없이 바텀 시트 띄우는 로직 (여긴 바텀시트 VC에 reactor 전달 x)
        mainView.bottomDiaryView.clearButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.presentFeedDetailMenuBottomSheetVC()
            }
            .disposed(by: disposeBag)
        
        // 추가 버튼 클릭 -> 생성 페이지 이동
        mainView.plusButton.rx.tap
            .map {
                return HomeCalendarReactor.Action.plusButtonTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: HomeCalendarReactor) {
        // feedDetail
        reactor.state.map { $0.currentFeedDetail }
            .distinctUntilChanged()
            .bind(onNext: { self.mainView.updateView($0) })
            .disposed(by: disposeBag)
        
        // currentYearMonth
        reactor.state.map { $0.currentYearMonth }
            .distinctUntilChanged()
            .bind(onNext: { self.mainView.calendarView.updateCalendar($0) })
            .disposed(by: disposeBag)
        
        // calendarThumbnails
        reactor.state.map { $0.currentThumbnails }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, list in
                // list를 가공해서 캘린더 셀에 띄워줘야 함.
                self.mainView.calendarView.calendar.reloadData()
            }
            .disposed(by: disposeBag)
        
        // load Data Again (after delete feed)
        reactor.state.map { $0.loadDataAgain }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, _ in
                let curDate = reactor.currentState.currentDate
                let curYearMonth = reactor.currentState.currentYearMonth
                reactor.action.onNext(.loadFeedDetail(curDate))
                reactor.action.onNext(.loadCalendarThumbnails(curYearMonth))
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Calendar
extension HomeCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    private func connectCalendar() {
        mainView.calendarView.calendar.delegate = self
        mainView.calendarView.calendar.dataSource = self
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: TToonCalendarCell.description(), for: date, at: position) as? TToonCalendarCell else { return FSCalendarCell() }
                
        // 1. current Date Setting
        // 현재 선택된 날짜이면 주황색 테두리
        cell.selectedBorderBackgroundView.isHidden = date.toString(of: .fulldate) != self.reactor?.currentState.currentDate.toString(of: .fulldate)
        
        
        // 2. current Calendar Thumbnail Setting
        if let list = self.reactor?.currentState.currentThumbnails {
            if let model = list.first(where: { $0.createdDate == date.toString(of: .fullWithHyphen) }) {
                cell.ttoonImageView.load(url: URL(string: model.thumbnailUrl))
            } else {
                cell.ttoonImageView.image = nil
            }
        }

        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 셀을 클릭할 때마다 전체 reload는 너무 비효율적임
        // 단순히 주황색 테두리 UI만 변경하기 위함이므로, cellFor 함수를 실행하지 말고, 여기서 조절(?)
        
        // 1. 기존에 선택된 셀의 주황색 테두리 없앰.
        if let previousDate = reactor?.currentState.currentDate,
           let cell = mainView.calendarView.calendar.cell(for: previousDate, at: monthPosition) as? TToonCalendarCell {
            print("해제 : \(previousDate)")
            cell.selectedBorderBackgroundView.isHidden = true
        }
        
        // 2. 새롭게 선택한 셀의 주황색 테두리 추가
        if let cell = mainView.calendarView.calendar.cell(for: date, at: monthPosition) as? TToonCalendarCell {
            print("등록 : \(date)")
            cell.selectedBorderBackgroundView.isHidden = false
        }
        
        // 새로운 피드 네트워크 콜
        self.reactor?.action.onNext(.loadFeedDetail(date))
        
        // 컬렉션뷰 위치 초기화
        mainView.bottomDiaryView.diaryImageSwipeCollectionView.setContentOffset(CGPoint(x: -16, y: 0), animated: false)
        mainView.bottomDiaryView.diaryImageSwipePageControl.currentPage = 0
    }
}

// MARK: - Swipe CollectionView
extension HomeCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func connectCollectionView() {
        mainView.bottomDiaryView.diaryImageSwipeCollectionView.delegate = self
        mainView.bottomDiaryView.diaryImageSwipeCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let idf = BottomDiaryImageSwipeCollectionViewCell.description()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idf, for: indexPath) as? BottomDiaryImageSwipeCollectionViewCell else { return UICollectionViewCell() }
        
        if let imageStr = self.reactor?.currentState.currentFeedDetail?.imageList[indexPath.row],
           let url = URL(string: imageStr)
        {
            cell.imageView.load(url: url)
        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = BottomDiaryView.Size.itemSize.width + BottomDiaryView.Size.itemSpacing
        let idx = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: idx * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        // pageControl의 page 변경
        if mainView.bottomDiaryView.diaryImageSwipePageControl.currentPage != Int(idx) {
            mainView.bottomDiaryView.diaryImageSwipePageControl.currentPage = Int(idx)
        }
    }
}

// MARK: - Feed Detail Menu Delegate
extension HomeCalendarViewController: FeedDetailMenuBottomSheetActionProtocol {
    func firstButtonTapped() {
        TNAlert(self)
            .setTitle("만화를 어떻게 저장하시겠어요?\n")
            .addCancelAction("네 컷을 따로") {
                self.reactor?.action.onNext(.saveTToonImage(.fourPage))
                print("네 컷")
            }
            .addConfirmAction("한 장으로") {
                self.reactor?.action.onNext(.saveTToonImage(.onePage))
                print("한 장")
            }
            .present()
    }
    
    func secondButtonTapped() {
        TNAlert(self)
            .setTitle("만화를 어떻게 공유하시겠어요?")
            .addCancelAction("네 컷을 따로") {
                self.reactor?.action.onNext(.shareTToonImage(.fourPage))
                print("네 컷")
            }
            .addConfirmAction("한 장으로") {
                self.reactor?.action.onNext(.shareTToonImage(.onePage))
                print("한 장")
            }
            .present()
    }
    
    func thirdButtonTapped() {
        self.reactor?.action.onNext(.deleteTToon)
    }
}

// MARK: - private func
extension HomeCalendarViewController {
    // 연월 선택 바텀시트
    private func presentSelectYearMonthBottomSheetVC() {
        let vc = SelectYearMonthBottomSheetViewController(self.reactor!)

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { _ in return 343 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(vc, animated: true)
    }
    
    // 디테일 옵션 바텀시트
    private func presentFeedDetailMenuBottomSheetVC() {
        let vc = FeedDetailMenuBottomSheetViewController()
        
        vc.delegate = self
        
        vc.menuView.setText(
            first: "이미지 저장하기",
            second: "공유하기",
            third: "삭제하기"
        )
        
        if let sheet = vc.sheetPresentationController {
            // 15 * 2 + 60 * 3 + 2
            sheet.detents = [.custom { _ in return 212 } ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(vc, animated: true)
    }
    
    // 화면 진입 시 필요한 데이터 로드
    private func loadInitialData() {
        print(#function)
        let initialDate = Date()
        
        self.reactor?.action.onNext(.loadCalendarThumbnails(initialDate.toString(of: .yearMonthKorean)))
        self.reactor?.action.onNext(.loadFeedDetail(initialDate))
    }
}
