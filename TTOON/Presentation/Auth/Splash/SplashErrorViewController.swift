//
//  SplashErrorViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/13/24.
//

import UIKit

import FlexLayout
import PinLayout

final class SplashErrorViewController: BaseViewController {
    // MARK: - UI Properties
    
    private lazy var errorImage = {
        let view = UIImageView()
        view.image = TNImage.splashLogo
        
        return view
    }()
    
    private lazy var errorLabel = {
        let view = UILabel()
        view.text = "에러 메세지"
        view.textColor = .black
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var retryButton = {
        let view = UIButton()
        view.setTitle("재시도", for: .normal)
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
                flex.addItem(errorImage)
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
}
