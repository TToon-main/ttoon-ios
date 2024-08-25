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
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .vertical
        view.spacing = 44
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(contentTableView)
        
        return view
    }()
    
    override func configures() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
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
        view.addSubview(confirmButton)
    }

    override func viewDidLayoutSubviews() {
        view.snp.makeConstraints { 
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-11)
        }
        
        container.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.horizontalEdges.equalToSuperview().inset(21)
            $0.centerX.equalToSuperview()
            
            if confirmButton.isHidden {
                $0.bottom.equalToSuperview().inset(50)
            } else {
                $0.bottom.equalTo(confirmButton.snp.top).offset(-16)
            }
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(21)
            $0.height.equalTo(56)
            $0.centerX.equalToSuperview()
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
