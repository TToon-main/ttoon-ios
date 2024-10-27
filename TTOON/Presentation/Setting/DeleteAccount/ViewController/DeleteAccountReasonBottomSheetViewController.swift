//
//  DeleteAccountReasonBottomSheetViewController.swift
//  TTOON
//
//  Created by 임승섭 on 7/9/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

class DeleteAccountReasonBottomSheetViewController: BaseViewController, View {
    // ContactUs의 CategoryBottomSheetVC와 거의 동일
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    var selectedReason: DeleteAccountReason? {
        didSet {
            self.bottomSheetView.completeButton.isEnabled = (selectedReason != nil)
        }
    }
    
    
    // MARK: - UI property
    // mainView를 변경하는 게 아니라, addSubView로 얹어둔다.
    let bottomSheetView = CategoryBottomSheetView()
    
    
    init(_ reactor: DeleteAccountReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setting
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(bottomSheetView)
    }
    
    override func layouts() {
        super.layouts()
        
        bottomSheetView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func configures() {
        super.configures()

        bottomSheetView.clipsToBounds = true
        bottomSheetView.layer.cornerRadius = 25
        setUpTableView()
    }
}

// reactor
extension DeleteAccountReasonBottomSheetViewController {
    func bind(reactor: DeleteAccountReactor) {
        bottomSheetView.completeButton.rx.tap
            .map {
                let reason = self.selectedReason!
                self.dismiss(animated: true)
                print("delete account bottom sheet complete button tapped")
                
                return DeleteAccountReactor.Action.deleteReason(reason)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}


// tableView
extension DeleteAccountReasonBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    private func setUpTableView() {
        bottomSheetView.categoryTableView.delegate = self
        bottomSheetView.categoryTableView.dataSource = self
        
        // 이미 선택된게 있으면, 체크해준다
        if let alreadySelectedReason = self.reactor?.currentState.deleteReason {
            self.selectedReason = alreadySelectedReason
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeleteAccountReason.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? TNSheetCellVer2 else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = DeleteAccountReason(rawValue: indexPath.row)?.description
        
        if let selectedIdx = self.selectedReason?.rawValue,
           selectedIdx == indexPath.row {
            cell.isChecked = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHeight = self.bottomSheetView.categoryTableView.frame.height
        let rowCnt = CGFloat(DeleteAccountReason.allCases.count)
        
        return tableViewHeight/rowCnt
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TNSheetCellVer2 else { return }
        
        cell.isChecked = true
        self.selectedReason = DeleteAccountReason(rawValue: indexPath.row)
        
        for i in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if i != indexPath.row {
                let otherIndexPath = IndexPath(row: i, section: indexPath.section)
                if let otherCell = tableView.cellForRow(at: otherIndexPath) as? TNSheetCellVer2 {
                    otherCell.isChecked = false
                }
            }
        }
    }
}
