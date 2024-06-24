//
//  SelectStyleViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class SelectStyleViewController: CreateToonBaseViewController {
    private let selectStyleView = SelectStyleView()
    var disposeBag = DisposeBag()
    
    init(reactor: SelectStyleReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = selectStyleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockData()
    }
}
extension SelectStyleViewController: View {
    func bindMockData() {
        let cells = ["그림체 1", "그림체 2", "그림체 3"]
        let items = BehaviorSubject(value: cells)
        
        // CollectionView 바인딩
        items.bind(to: selectStyleView.createToonCollectionView.rx
            .items(cellIdentifier: CreateToonCollectionViewCell.IDF, 
                   cellType: CreateToonCollectionViewCell.self)) 
        { index, item, cell in 
            cell.titleLabel.text = item
        }
        .disposed(by: disposeBag)
    }
    
    func bind(reactor: SelectStyleReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectStyleReactor) {
        selectStyleView.rx
            .modelSelected
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectStyleReactor) {
        reactor.state
            .map { $0.isEnabledConfirmButton }
            .bind(to: selectStyleView.rx.isEnabledConfirmButton)
            .disposed(by: disposeBag)
        
        selectStyleView.createToonConfirmButton.rx
            .tap
            .subscribe(with: self ) { owner, _ in
                let vc = EnterInfoViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
