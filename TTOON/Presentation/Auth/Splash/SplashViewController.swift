//
//  SplashViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 4/13/24.
//

import UIKit

import PinLayout

final class SplashViewController: BaseViewController {
    // MARK: - UI Properties
    
    private lazy var logo = {
        let view = UIImageView()
        view.image = TNImage.splashLogo
        
        return view
    }()
    
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
}
