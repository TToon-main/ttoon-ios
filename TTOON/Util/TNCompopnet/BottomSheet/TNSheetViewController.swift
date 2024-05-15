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
    private let disposeBag = DisposeBag()
    weak var delegate: SelectedIndexDelegate?
    
    lazy var contentTableViewDataSource: [String] = [] {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    var selectedIndex: IndexPath? 
    
    lazy var titleLabel = {
        let view = UILabel()
        view.font = .title20b
        view.textColor = .black
        
        return view
    }()
    
    lazy var contentTableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(TNSheetCell.self, forCellReuseIdentifier: "TNSheetCell")
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        
        return view
    }()
    
    lazy var confirmButton = {
        let view = TNButton()
        
        return view
    }()
    
    lazy var container = {
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
                owner.delegate?.selectedIndex(index: owner.selectedIndex?.row ?? 0)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        if confirmButton.isHidden {
            contentTableView.rx.itemSelected
                .subscribe(with: self) { owner, indexPath in
                    owner.delegate?.selectedIndex(index: indexPath.row)
                    owner.dismiss(animated: true)
                }
                .disposed(by: disposeBag)
        } 
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
                    .marginBottom(16)
                    .alignItems(.center)
                    .shrink(1) // 줄이기
                    .grow(1) 
                
                flex.addItem(confirmButton)
                    .marginHorizontal(16)
                    .marginBottom(16)
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
        
        if let selectedIndex = self.selectedIndex {
            if selectedIndex == indexPath {
                cell.isChecked.toggle()
            }  
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
