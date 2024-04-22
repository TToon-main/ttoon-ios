//
//  SplashViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/13/24.
//

import UIKit

import PinLayout
import RxCocoa
import RxSwift

final class SplashViewController: BaseViewController {
    // MARK: - Properties
    let splashViewModel: SplashViewModel
    let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    private lazy var logo = {
        let view = UIImageView()
        view.image = TNImage.splashLogo
        
        return view
    }()
    
    // MARK: - Initializer
    
    init(splashViewModel: SplashViewModel) {
        self.splashViewModel = splashViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func configures() {
        view.backgroundColor = .white
        bind()
    }
    
    override func addSubViews() {
        view.addSubview(logo)
    }
    
    override func layouts() {
        logo.pin
            .center()
            .size(CGSize(width: 96, height: 99))
    }
    
    func bind() {
        let viewDidLoad = Observable.just(())
        let input = SplashViewModel.Input(viewDidLoad: viewDidLoad)
        let output = splashViewModel.transform(input: input)
        
        output.splashStatus
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
            let vm = SplashErrorViewModel(splashUseCase: useCase)
            let vc = SplashErrorViewController(splashErrorViewModel: vm)
            vc.splashStatus = status
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)   
        }
    }
}
