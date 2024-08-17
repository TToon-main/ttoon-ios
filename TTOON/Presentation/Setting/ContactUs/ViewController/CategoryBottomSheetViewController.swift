//
//  CategoryBottomSheetViewController.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class CategoryBottomSheetViewController: BaseViewController, View {
    // MARK: - property
    var disposeBag = DisposeBag()
    
    // 뭘 체크했는지 저장 - nil이 아니면 무언가 선택되었다고 간주하고, 완료 버튼 활성화
    var selectedCategory: ContactCategory? {
        didSet {
            self.bottomSheetView.completeButton.isEnabled = (selectedCategory != nil)
        }
    }
    
    
    // MARK: - UI property
    // 기본 뷰는 그대로. 회색 배경으로만 변경
    // 그 위에 CategoryBottomSheetView 인스턴스 얹어두는 형식
    // 즉, mainView를 변경하는 형식은 아님
    let bottomSheetView = CategoryBottomSheetView()
    
    

    
    // 문의하기 화면의 뷰모델을 전달받는다.
    init(_ reactor: ContactUsReactor) {
        super.init(nibName: nil, bundle: nil)
    
        
        self.reactor = reactor
//        bind(reactor: reactor)    // 완료 버튼을 누르면 액션만 넘겨준다.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(bottomSheetView)
    }
    
    override func layouts() {
        super.layouts()
        
        bottomSheetView.snp.makeConstraints { make in
            make.bottom.equalTo(view).inset(24)
            make.horizontalEdges.equalTo(view).inset(16)
            make.height.equalTo(489)
        }
    }
    
    override func configures() {
        super.configures()
        
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
        
        bottomSheetView.clipsToBounds = true
        bottomSheetView.layer.cornerRadius = 25
        
        setUpTableView()
    }
}

// reactor bind
extension CategoryBottomSheetViewController {
    func bind(reactor: ContactUsReactor) {
        // 액션만 진행! 완료버튼 클릭시 선택한 카테고리 action으로 넘겨주기
        bottomSheetView.completeButton.rx.tap
            .map {
                let category = self.selectedCategory!
                self.dismiss(animated: true)
                
                return ContactUsReactor.Action.categoryTapped(category)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// 테이블뷰
extension CategoryBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    // 피그마 : 문자열 높이 22, 이미지 높이 24, 문자열 사이 간격 36
    // => 셀 높이 40으로 설정
    
    private func setUpTableView() {
        bottomSheetView.categoryTableView.delegate = self
        bottomSheetView.categoryTableView.dataSource = self
        
        // 이미 선택된 카테고리가 있으면, selectedCategory에 저장
        // 저장되면 didSet
        if let alreadySelectedCategory = self.reactor?.currentState.category  {
            self.selectedCategory = alreadySelectedCategory
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? TNSheetCell else { return UITableViewCell() }
        
        cell.titleLabel.text = ContactCategory(rawValue: indexPath.row)?.description
        
        if let selectedIdx = self.selectedCategory?.rawValue,
           selectedIdx == indexPath.row {
            cell.isChecked = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 현재 테이블뷰 높이를 계산하고, 그거 나누기 개수
        let tableViewHeight = self.bottomSheetView.categoryTableView.frame.height
        let rowCnt = CGFloat(ContactCategory.allCases.count)
        
        return tableViewHeight/rowCnt
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TNSheetCell else { return }
        cell.isChecked = true
        self.selectedCategory = ContactCategory(rawValue: indexPath.row)
        
        // 선택된 셀 외의 모든 셀의 isChecked를 false로 설정하여 단일 선택을 유지합니다.
        for i in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if i != indexPath.row {
                let otherIndexPath = IndexPath(row: i, section: indexPath.section)
                if let otherCell = tableView.cellForRow(at: otherIndexPath) as? TNSheetCell {
                    otherCell.isChecked = false
                }
            }
        }
    }
}
