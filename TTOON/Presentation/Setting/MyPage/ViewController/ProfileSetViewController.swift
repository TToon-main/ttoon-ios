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
}

extension ProfileSetViewController: View {
    func bind(reactor: ProfileSetReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: ProfileSetReactor) {
    }
    
    func bindState(_ reactor: ProfileSetReactor) {
    }
}
