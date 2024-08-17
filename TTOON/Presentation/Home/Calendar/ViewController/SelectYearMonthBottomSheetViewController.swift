//
//  SelectYearMonthBottomSheetViewController.swift
//  TTOON
//
//  Created by 임승섭 on 7/20/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

// TODO: 초기 세팅 해야 함 (reactor에 저장된 값 기반으로 세팅)
class SelectYearMonthBottomSheetViewController: BaseViewController, View {
    // MARK: - property
    var disposeBag = DisposeBag()
    
    // pickerView에 들어갈 값들 저장. (2020년 1월부터 현재 날짜까지)
    var yearMonthList: [String] = createYearMonthList()
    
    // pickerView에서 선택한 날짜 (reactor currentState 기반으로 초기 세팅
    var selectedYearMonth: String = ""  // 편의를 위해 yyyy년 M월 포맷으로 저장
    
    
    // MARK: - UI
    // 기본 뷰는 그대로. 회색 배경으로만 변경
    let bottomSheetView = SelectYearMonthBottomSheetView()
    
    // HomeCalendarView의 리액터 전달받는다.
    init(_ reactor: HomeCalendarReactor) {
        super.init(nibName: nil, bundle: nil)
    
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectPickerView()
        settingPickerView()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(bottomSheetView)
    }
    
    override func layouts() {
        super.layouts()
        
        bottomSheetView.snp.makeConstraints { make in
            make.bottom.equalTo(view).inset(36)
            make.horizontalEdges.equalTo(view).inset(16)
            make.height.equalTo(312)
        }
    }
    
    override func configures() {
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
        
        bottomSheetView.clipsToBounds = true
        bottomSheetView.layer.cornerRadius = 25
    }
}

// reactor bind
extension SelectYearMonthBottomSheetViewController {
    func bind(reactor: HomeCalendarReactor) {
        // 취소 버튼 클릭
        // self.dismiss
        bottomSheetView.cancelButton.rx.tap
            .subscribe(with: self) { owner, _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        
        // 완료 버튼 클릭
        // 1. self.dismiss
        // 2. reactor action 전달 (
        bottomSheetView.completeButton.rx.tap
            .map {
                // 1.
                self.dismiss(animated: true)
                
                // 2.
                return HomeCalendarReactor.Action.selectYearMonth(self.selectedYearMonth)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}


// PickerView
extension SelectYearMonthBottomSheetViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    private func connectPickerView() {
        bottomSheetView.pickerView.delegate = self
        bottomSheetView.pickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearMonthList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearMonthList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedYearMonth = yearMonthList[row]
    }
}


// private func
extension SelectYearMonthBottomSheetViewController {
    // 2020년 1월 ~ 현재 날짜까지 문자열 배열 만들기
    static func createYearMonthList() -> [String] {
        var dateArr: [String] = []
    
        let calendar = Calendar.current
        let currentDate = Date()
        
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = 1
        
        let startDate = "2020년 1월".toDate(to: .yearMonthKorean)!
        
        var date = startDate
        while date <= currentDate {
            dateArr.append(date.toString(of: .yearMonthKorean))
            if let nextDate = calendar.date(byAdding: .month, value: 1, to: date) {
                date = nextDate
            } else { break }
        }
        
        return dateArr
    }
    
    // pickerView 초기 세팅
    private func settingPickerView() {
        if let currentYearMonth = reactor?.currentState.currentYearMonth {
            self.selectedYearMonth = currentYearMonth
            bottomSheetView.pickerView.selectRow(
                yearMonthList.firstIndex(of: currentYearMonth) ?? 3,
                inComponent: 0,
                animated: true
            )
        }
    }
}
