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
    
    // MARK: - UI Component (View)
    let mainView = HomeCalendarView()
    
    
    
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
        
        connectCalendar() // 캘린더
        connectCollectionView() // 스와이프 컬렉션뷰
        
//        // sample
//        view.backgroundColor = .white
//        view.addSubview(calendarView)
//        calendarView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(view)
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.height.equalTo(409)
//        }
    }
}

// MARK: - ReactorKit
extension HomeCalendarViewController {
    func bind(reactor: HomeCalendarReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: HomeCalendarReactor) {
        // 캘린더 셀 선택
        self.calendarCellDidSelected
            .map {
                HomeCalendarReactor.Action.didSelectCalendarCell($0)
            }
            .bind(to: reactor.action)
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
        self.calendarCellDidSelected.onNext(date)
    }
}

// MARK: - Swipe CollectionView
extension HomeCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
}
