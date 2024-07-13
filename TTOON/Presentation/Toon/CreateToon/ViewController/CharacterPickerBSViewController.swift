//
//  CharacterPickerBSViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/13/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CharacterPickerBSViewController: BaseViewController {
    var disposeBag = DisposeBag()
    private let characterPickerBSView = CharacterPickerBSView()
    
    init(reactor: CharacterPickerBSReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterPickerBSView
    }
}
extension CharacterPickerBSViewController: View {
    func bind(reactor: CharacterPickerBSReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: CharacterPickerBSReactor) {
    }
    
    func bindState(reactor: CharacterPickerBSReactor) {
    }
}
