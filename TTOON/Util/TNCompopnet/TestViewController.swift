//
//  TestViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/8/24.
//


import UIKit

import PinLayout
import RxCocoa
import RxSwift

final class TestViewController: BaseViewController {
    private lazy var testButton = {
        let view = TNButton()
        view.setTitle("테스트", for: .normal)
        
        return view
    }()
    
    private lazy var cancelTestButton = {
        let view = TNAlertButton()
        view.setTitle("테스트", for: .normal)
        view.type = .cancel
        
        return view
    }()
    
    private lazy var confirmTestButton = {
        let view = TNAlertButton()
        view.setTitle("테스트", for: .normal)
        view.type = .confirm
        
        return view
    }()
    
    override func configures() {
        view.backgroundColor = .white
    }
    
    override func addSubViews() {
        view.addSubview(testButton)
        view.addSubview(cancelTestButton)
        view.addSubview(confirmTestButton)
    }
    
    override func layouts() {
        testButton.pin
            .center()
            .width(343)
            .height(56)
        
        cancelTestButton.pin
            .top(to: testButton.edge.bottom)
            .hCenter()
            .width(141)
            .height(56)
        
        confirmTestButton.pin
            .top(to: cancelTestButton.edge.bottom)
            .hCenter()
            .width(141)
            .height(56)
    }
}
