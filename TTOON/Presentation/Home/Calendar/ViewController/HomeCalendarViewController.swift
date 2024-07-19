//
//  HomeCalendarViewController.swift
//  TTOON
//
//  Created by 임승섭 on 7/18/24.
//

import FSCalendar
import UIKit

class HomeCalendarViewController: BaseViewController {
    // MARK: - UI Component (View)
//    let calendarView = CalendarView()
    let mainView = HomeCalendarView()
    
    var currentIdx: CGFloat = 0
    
    
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



// MARK: - Calendar
extension HomeCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    private func connectCalendar() {
        mainView.calendarView.calendar.delegate = self
        mainView.calendarView.calendar.dataSource = self
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: TToonCalendarCell.description(), for: date, at: position) as? TToonCalendarCell else { return FSCalendarCell() }
        
        cell.ttoonImageView.isHidden = [0, 1].randomElement()! == 0
        
        cell.selectedBorderBackgroundView.isHidden = Calendar.current.dateComponents([.day], from: date).day != 18
        
        return cell
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("********")
        if let cv = scrollView as? UICollectionView {
            guard let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            
            let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
            
            var offset = targetContentOffset.pointee
            let idx = round((offset.x + cv.contentInset.left) / cellWidth)
            
            if idx > currentIdx {
                currentIdx += 1
            } else if idx < currentIdx {
                if currentIdx != 0 {
                    currentIdx -= 1
                }
            }
            
            offset = CGPoint(x: currentIdx * cellWidth - cv.contentInset.left, y: 0)
            
            targetContentOffset.pointee = offset
        }
    }
}
