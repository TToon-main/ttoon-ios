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
//                    owner.presentErrorVC(.disConnected)
                    print("VC에서 화면 전환 로직 생략")
                    
                case .inMaintenance:
//                    owner.presentErrorVC(.inMaintenance)
                    print("VC에서 화면 전환 로직 생략")
                    
                case .needUpdate:
//                    owner.presentErrorVC(.needUpdate)
                    print("VC에서 화면 전환 로직 생략")
                    
                case .valid:
//                    owner.presentMainVC()
                    print("VC에서 화면 전환 로직 생략")
                }
            }
            .disposed(by: disposeBag)
    }
    
//    // 의도적으로 2초의 delayTime 부여
//    func presentErrorVC(_ status: SplashStatus) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let repo = SplashRepository()
//            let useCase = SplashUseCase(splashRepository: repo)
//            let reactor = SplashErrorReactor(splashUseCase: useCase, splashStatus: status)
//            let vc = SplashErrorViewController(splashErrorReactor: reactor)
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            self.present(vc, animated: true)   
//        }
//    }
    
//    // splashStatus의 상태가 valid일 경우 메인 화면 진입
//    // token이 유효성에 따라서, 홈화면으로 바로 진입 or 로그인 화면으로 진입
//    func presentMainVC() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let isTokenValidate = false // 토큰 유효한지 여부 BoolType
//            isTokenValidate ? self.presetHomeVC() : self.presetLoginVC()
//        }
//    }
//    
//    // 로그인 화면으로 진입: 토큰 만료
//    func presetLoginVC() {
//        print("로그인 화면으로 진입: 토큰 만료")
//    }
//    
//    // 홈 화면으로 진입: 토큰 유효
//    func presetHomeVC() {
//        print("홈 화면으로 진입: 토큰 유효")
//    }
}
