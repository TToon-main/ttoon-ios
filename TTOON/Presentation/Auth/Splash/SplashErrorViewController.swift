//
//  SplashErrorViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/13/24.
//

import UIKit

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class SplashErrorViewController: BaseViewController {
    // MARK: - UI Properties
    
    var splashStatus: SplashStatus?
    let splashErrorViewModel: SplashErrorViewModel
    let disposeBag = DisposeBag()
    
    private lazy var errorImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    private lazy var errorLabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var retryButton = {
        let view = UIButton()
        view.setTitleColor(.black, for: .normal)
        view.layer.cornerRadius = 16
        view.backgroundColor = .bgGrey04
        
        return view
    }()
    
    private lazy var container = {
        let view = UIView()
        view.backgroundColor = .bgGrey01
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    init(splashErrorViewModel: SplashErrorViewModel) {
        self.splashErrorViewModel = splashErrorViewModel
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
        view.addSubview(container)
    }
    
    override func layouts() {
        container.flex
            .alignItems(.center)
            .define { flex in
                flex.addItem(errorImageView)
                    .marginTop(16)
                    .size(50)
                
                flex.addItem(errorLabel)
                    .marginTop(16)
                    .marginHorizontal(16)
                
                flex.addItem(retryButton)
                    .marginVertical(16)
                    .width(100)
                    .height(50)
            }
    }
    
    override func viewDidLayoutSubviews() {
        container.pin
            .left(10%)
            .right(10%)
        
        container.flex.layout(mode: .adjustHeight)
        
        container.pin
            .center()
    }
    
    func bind() {
        let viewDidLoad = Observable.just(())
        let retryButtonTap = retryButton.rx.tap.map{ self.splashStatus! }.share()
        
        let input = SplashErrorViewModel.Input(viewDidLoad: viewDidLoad, 
                                               retryButtonTap: retryButtonTap)
        
        let output = splashErrorViewModel.transform(input: input)
        
        output.checkStatus
            .subscribe(with: self) { owner, _ in 
                guard let status = owner.splashStatus else { return }
                owner.checkStatus(status)
            }
            .disposed(by: disposeBag)
        
        output.isConnected
            .subscribe(with: self) { owner, isSuccess in 
                isSuccess ? owner.dismiss(animated: true) : print("재시도 얼럿")
            }
            .disposed(by: disposeBag)
        
        output.moveStore
            .subscribe(with: self) { owner, _ in
                let url = ""
                owner.moveStore(url: url)
            }
            .disposed(by: disposeBag)
    }
    
    func checkStatus(_ status: SplashStatus) {
        switch status { 
        case .disConnected:
            updateUI(image: TNImage.splashLogo,
                     lbText: "인터넷 연결 필요",
                     btnTitle: "재시도")
            
        case .inMaintenance:
            updateUI(image: TNImage.splashLogo,
                     lbText: "서버 점검 중",
                     btnTitle: nil,
                     isHiddenBtn: true)
            
        case .needUpdate:
            updateUI(image: TNImage.splashLogo,
                     lbText: "업데이트 필요",
                     btnTitle: "이동")            

        case .valid:
            break
        }
    }

    func updateUI(image: UIImage?, lbText: String, btnTitle: String?, isHiddenBtn: Bool = false) {
        errorImageView.image = image
        errorLabel.text = lbText 
        retryButton.setTitle(btnTitle, for: .normal)
        retryButton.isHidden = isHiddenBtn
    }
    
    func moveStore(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
