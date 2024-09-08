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
    
    let calendarCellDidSelected = PublishSubject<Date>() // FSCalendar의 rx.didSelect가 없어서 이걸 통해 이벤트를 전달한다.
    
    
    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 0
    
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
        
        setTToonLogHomeNavigation(ttoonNavigationView)
        connectCalendar() // 캘린더
        connectCollectionView() // 스와이프 컬렉션뷰
    }
}

// MARK: - ReactorKit bind
extension HomeCalendarViewController {
    func bind(reactor: HomeCalendarReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: HomeCalendarReactor) {
        // 네비게이션 버튼 눌렀을 때 액션 전달
        ttoonNavigationView.friendListButton.rx.tap
            .map {
                HomeCalendarReactor.Action.friendListButtonTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // 캘린더 셀 선택
        self.calendarCellDidSelected
            .map {
                HomeCalendarReactor.Action.didSelectCalendarCell($0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 연월 변경 버튼 클릭 - 따로 reactor에 bind 없이 바텀 시트 띄우는 로직
        mainView.calendarView.selectYearMonthView.clearButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = SelectYearMonthBottomSheetViewController(self.reactor!)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: HomeCalendarReactor) {
        // currentDate
        reactor.state.map { $0.currentDate }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, date in
                // 캘린더 reload
                owner.mainView.calendarView.calendar.reloadData()
                
                // diaryView 날짜 변경
                // 아마 이건, 여기서 바꾸는 게 아니라 detailData가 바뀌는 지점에서 해야 할 듯 하다.
                owner.mainView.bottomDiaryView.updateDate(date) // 날짜 따로 변경하고,
                
                
                // TODO: diaryView reload
            }
            .disposed(by: disposeBag)
        
        // currentYearMonth - 어차피 CurrentDate도 수정되기 때문에 중복된 코드는 없애자.
        reactor.state.map { $0.currentYearMonth }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, yearMonth in
                owner.mainView.calendarView.selectYearMonthView.updateYearMonth(yearMonth)
                
                owner.mainView.calendarView.updateCalendar(yearMonth)
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
        
        /* ===  sample code === */
        let aa = Calendar.current.dateComponents([.day], from: date).day!
        if aa % 9 == 0 { cell.ttoonImageView.image = UIImage(named: "sample1") }
        else if aa % 4 == 0 { cell.ttoonImageView.image = UIImage(named: "sample2") }
        else if aa % 5 == 0 { cell.ttoonImageView.image = UIImage(named: "sample3") }
        else { cell.ttoonImageView.image = nil }
        
        
        // 현재 선택된 날짜이면 주황색 테두리
        cell.selectedBorderBackgroundView.isHidden = date.toString(of: .fulldate) != self.reactor?.currentState.currentDate.toString(of: .fulldate)
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 셀을 클릭했다는 이벤트를 이러한 방식으로 전달한다.
        self.calendarCellDidSelected.onNext(date)
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
        
        cell.imageView.image = UIImage(named: "sample4")
        
        cell.backgroundColor = .grey01
        
        return cell
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let point = self.targetContentOffset(scrollView, withVelocity: velocity)
//        targetContentOffset.pointee = point
//        
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
//            self.mainView.bottomDiaryView.diaryImageSwipeCollectionView.setContentOffset(point, animated: true)
//        }, completion: nil)
//    }
//    
//    func targetContentOffset(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) -> CGPoint {
//        let collectionView = self.mainView.bottomDiaryView.diaryImageSwipeCollectionView
//        
//        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
//        
//        if self.previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
//            currentPage -= 1
//        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
//            currentPage += 1
//        }
//        
//        let additional = (flowLayout.itemSize.width + flowLayout.minimumLineSpacing) - flowLayout.headerReferenceSize.width
//        
//        let updatedOffset = (flowLayout.itemSize.width + flowLayout.minimumLineSpacing) * CGFloat(currentPage) - additional
//        
//        previousOffset = updatedOffset
//        
//        return CGPoint(x: updatedOffset, y: 0)
//    }
}
