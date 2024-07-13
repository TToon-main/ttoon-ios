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

class CharacterEditorViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterEditorView = CharacterEditorView()
    
    init(reactor: CharacterEditorReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterEditorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindMockUp()
    }
    
    override func configures() {
        setNavigationItem()
    }
    
    // TODO: 임시
    func bindMockUp() {
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "등장인물 수정"
        self.navigationItem.backButtonTitle = ""
        
        // TODO: 임시
        let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteAction))
        deleteButton.tintColor = .errorRed
        deleteButton.setTitleTextAttributes([.font: UIFont.body16m], for: .normal)

        self.navigationItem.rightBarButtonItem = deleteButton
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @objc func deleteAction() {
        // 삭제 버튼이 눌렸을 때 수행할 동작을 여기에 구현
        print("삭제 버튼이 눌렸습니다.")
    }
}

extension CharacterEditorViewController: View {
    func bind(reactor: CharacterEditorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterEditorReactor) {
    }
    
    func bindState(reactor: CharacterEditorReactor) {
    }
}
