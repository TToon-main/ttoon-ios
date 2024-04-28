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
            .size(CGSize(width: 96, height: 99))
    }
    
    func bind(reactor: SplashReactor) {
        bindAction(reactor)
        bindState(reactor)  
    }
            
    func bindAction(_ reactor: SplashReactor) {
        Observable.just(())
                .map { SplashReactor.Action.viewDidLoad }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: SplashReactor) {
        reactor.state.map { $0.splashStatus }
            .compactMap { $0 }
            .subscribe(with: self) { owner, status in 
                switch status {
                case .disConnected:
                    owner.presentVC(.disConnected)
                    print("CHECK disConnected")
                    
                case .inMaintenance:
                    owner.presentVC(.inMaintenance)
                    print("CHECK inMaintenance")
                    
                case .needUpdate:
                    owner.presentVC(.needUpdate)
                    print("CHECK needUpdate")
                    
                case .valid:
                    print("CHECK: 메인 화면 진입")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func presentVC(_ status: SplashStatus) {
        DispatchQueue.main.async {
            let repo = SplashRepository()
            let useCase = SplashUseCase(splashRepository: repo)
            let reactor = SplashErrorReactor(splashUseCase: useCase, splashStatus: status)
            let vc = SplashErrorViewController(splashErrorReactor: reactor)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)   
        }
    }
}
