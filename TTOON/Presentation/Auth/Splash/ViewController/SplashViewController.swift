//
//  SplashViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/13/24.
//

import UIKit

import PinLayout
import ReactorKit
import RxCocoa
import RxSwift

final class SplashViewController: BaseViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    private lazy var logo = {
        let view = UIImageView()
        view.image = TNImage.splashLogo
        
        return view
    }()
    
    // MARK: - Initializer
    
    init(splashReactor: SplashReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = splashReactor 
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func configures() {
        view.backgroundColor = .white
    }
    
    override func addSubViews() {
        view.addSubview(logo)
    }
    
    override func layouts() {
        logo.pin
            .center()
            .size(CGSize(width: 168, height: 144))
    }
    
    func bind(reactor: SplashReactor) {
        bindAction(reactor)
    }
            
    func bindAction(_ reactor: SplashReactor) {
        Observable.just(())
                .map { SplashReactor.Action.viewDidLoad }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
    }
}
