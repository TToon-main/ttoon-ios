//
//  ProfileSetViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/25/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class ProfileSetViewController: BaseViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    private let profileSetView = ProfileSetView()
    
    // MARK: - Init
    init(profileSetReactor: ProfileSetReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = profileSetReactor 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    override func loadView() {
        view = profileSetView
    }
    
    override func configures() {
        setNavigationItem()
        hideKeyboardWhenTappedAround()
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "프로필 설정"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension ProfileSetViewController: View {
    func bind(reactor: ProfileSetReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    func bindAction(_ reactor: ProfileSetReactor) {
        rx.viewWillAppear
            .map { _ in ProfileSetReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileSetView.rx.copyButtonTap
            .map { ProfileSetReactor.Action.copyButtonTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileSetView.rx.textFiledText
            .map { ProfileSetReactor.Action.truncateNickName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: ProfileSetReactor) {
        reactor.state
            .compactMap { $0.profileInfo }
            .bind(to: profileSetView.rx.model)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.truncatedText }
            .bind(to: profileSetView.rx.truncatedText)
            .disposed(by: disposeBag)
    }
}
