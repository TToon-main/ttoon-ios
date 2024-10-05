//
//  CharacterEditorViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterAddViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterEditorScrollView = CharacterEditorScrollView()
    
    init(reactor: CharacterAddReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterEditorScrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockUp()
    }
    
    override func configures() {
        setNavigationItem()
        characterEditorScrollView.characterEditorView.setUpView(editType: .add)
    }
    
    // TODO: 임시
    func bindMockUp() {
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "등장인물 추가"
        self.navigationItem.backButtonTitle = ""
    }
}

extension CharacterAddViewController: View {
    func bind(reactor: CharacterAddReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterAddReactor) {
    }
    
    func bindState(reactor: CharacterAddReactor) {
    }
}
