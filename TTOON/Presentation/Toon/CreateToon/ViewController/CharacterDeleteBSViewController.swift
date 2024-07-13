//
//  CharacterDeleteBSViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterDeleteBSViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterDeleteBSView = CharacterDeleteBSView()
    
    init(reactor: CharacterDeleteBSReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterDeleteBSView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockUp()
    }
    
    func bindMockUp() {
    }
}

extension CharacterDeleteBSViewController: View {
    func bind(reactor: CharacterDeleteBSReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterDeleteBSReactor) {
    }
    
    func bindState(reactor: CharacterDeleteBSReactor) {
    }
}
