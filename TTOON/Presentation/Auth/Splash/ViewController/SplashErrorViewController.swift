//
//  SplashErrorViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/13/24.
//

import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import RxSwift

final class SplashErrorViewController: BaseViewController, View {
    // MARK: - UI Properties
    var disposeBag = DisposeBag()
    
    private lazy var errorImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    private lazy var errorTitleLabel = {
        let view = UILabel()
        view.textColor = .grey08
        view.font = .title20b
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var errorSubTitleLabel = {
        let view = UILabel()
        view.textColor = .grey05
        view.font = .body14m
        view.numberOfLines = 0
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var retryButton = {
        let view = UIButton()
        view.titleLabel?.font = .body16b
        view.setTitleColor(.grey07, for: .normal)
        view.backgroundColor = .grey02
        view.layer.cornerRadius = 14
        
        return view
    }()
    
    private lazy var container = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    // MARK: - Initializer
    
    init(splashErrorReactor: SplashErrorReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = splashErrorReactor 
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
        view.addSubview(container)
    }
    
    override func layouts() {
        container.flex
            .alignItems(.center)
            .define { flex in
                flex.addItem(errorImageView)
                    .size(111)
                
                flex.addItem(errorTitleLabel)
                    .marginTop(30)
                
                flex.addItem(errorSubTitleLabel)
                    .marginTop(12)
                    .marginHorizontal(26)
                
                flex.addItem(retryButton)
                    .marginTop(36)
                    .width(141)
                    .height(52)
            }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.pin
            .top(31%)
            .horizontally()
        
        container.flex.layout(mode: .adjustHeight)
    }
    
    func bind(reactor: SplashErrorReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindAction(_ reactor: SplashErrorReactor) {
        Observable.just(())
            .map { SplashErrorReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        retryButton.rx.tap
            .map{ SplashErrorReactor.Action.retryButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: SplashErrorReactor) {
        reactor.state
            .map { $0.splashStatus }
            .compactMap { $0 }
            .bind { self.checkStatus($0) }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isConnected }
            .compactMap { $0 }
            .subscribe(with: self) { owner, isSuccess in 
                isSuccess ? print("메인 화면 이동") : print("재시도 토스트")
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.moveStore }
            .compactMap { $0 }
            .subscribe(with: self) { owner, _ in
                owner.moveStore()
            }
            .disposed(by: disposeBag)
    }
    
    func checkStatus(_ status: SplashStatus) {
        switch status { 
        case .disConnected:
            updateUI(image: TNImage.splashLogo,
                     lbText: "인터넷 연결이 필요해요",
                     subText: "서비스 이용을 위해서는\n네트워크 연결을 해주세요!",
                     btnTitle: "재시도")
            
        case .needUpdate:
            updateUI(image: TNImage.splashLogo,
                     lbText: "업데이트가 필요해요",
                     subText: "최신 버전으로 업데이트가 필요해요.\n스토어에서 최신 버전을 다운 받아주세요!",
                     btnTitle: "스토어로 이동")            
            
        case .valid:
            break
        }
    }
    
    func updateUI(image: UIImage?, lbText: String, subText: String, btnTitle: String?, isHiddenBtn: Bool = false) {
        print(#function)
        errorImageView.image = image
        errorTitleLabel.text = lbText 
        errorSubTitleLabel.text = subText
        retryButton.setTitle(btnTitle, for: .normal)
        retryButton.isHidden = isHiddenBtn
    }
    
    func moveStore() {
        if let url = URL(string: TNUrl.storeUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
