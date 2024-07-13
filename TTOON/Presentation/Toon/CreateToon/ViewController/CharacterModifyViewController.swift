//
//  CharacterModifyViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterModifyViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterModifyView = CharacterModifyView()
    
    init(reactor: CharacterModifyReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterModifyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockUp()
    }
    
    override func configures() {
        setNavigationItem()
    }
    
    private func bindMockUp() {
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "등장인물 목록"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension CharacterModifyViewController: View {
    func bind(reactor: CharacterModifyReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterModifyReactor) {
    }
    
    func bindState(reactor: CharacterModifyReactor) {
    }
}
