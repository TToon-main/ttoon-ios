//
//  TNSheetViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/12/24.
//

import UIKit

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

protocol SelectedIndexDelegate: AnyObject {
    func selectedIndex(index: Int)
}

class TNSheetViewController: BaseViewController {
    lazy var contentTableViewDataSource: [String] = []
    var selectedIndex: IndexPath?
    
    private let disposeBag = DisposeBag()
    weak var delegate: SelectedIndexDelegate?
    
    lazy var titleLabel = {
        let view = UILabel()
        view.font = .title20b
        view.textColor = .black
        view.text = "샘플"
        
        return view
    }()
    
    lazy var contentTableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(TNSheetCell.self, forCellReuseIdentifier: "TNSheetCell")
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        
        return view
    }()
    
    lazy var confirmButton = {
        let view = TNButton()
        view.setTitle("확인", for: .normal)
        
        return view
    }()
    
    private lazy var container = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    override func configures() {
        view.backgroundColor = .white
        bind()
    }
    
    func bind() {
        confirmButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func addSubViews() {
        view.addSubview(container)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.pin
            .all(view.pin.safeArea)
        
        container.flex.layout(mode: .fitContainer)
    }
    
    override func layouts() {
        container.flex
            .direction(.column)
            .define { flex in
                flex.addItem(titleLabel)
                    .marginTop(44)
                    .marginHorizontal(21)
                    .alignItems(.start)
                
                flex.addItem(contentTableView)
                    .marginTop(44)
                    .marginHorizontal(20)
                    .alignItems(.center)
                    .grow(1)
                
                flex.addItem(confirmButton)
                    .marginTop(41)
                    .marginHorizontal(16)
                    .height(56)
                    .alignItems(.center)
            }
    }
}

extension TNSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentTableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TNSheetCell", for: indexPath) as? TNSheetCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = contentTableViewDataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TNSheetCell else {
            return
        }
        
        if let selectedIndex = self.selectedIndex,
            let prevCell = tableView.cellForRow(at: selectedIndex) as? TNSheetCell {
            prevCell.isChecked.toggle()
        }
        
        self.selectedIndex = indexPath
        cell.isChecked.toggle()
        delegate?.selectedIndex(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
