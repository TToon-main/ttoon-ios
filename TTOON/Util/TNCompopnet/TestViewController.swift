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
        view.setTitle("바텀 시트", for: .normal)
        view.type = .cancel
        view.addTarget(self, action: #selector(cancelTestButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var confirmTestButton = {
        let view = TNAlertButton()
        view.setTitle("얼럿", for: .normal)
        view.type = .confirm
        view.addTarget(self, action: #selector(confirmTestButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var testSwitch = {
        let view = TNSwitch()
        
        return view
    }()
    
    @objc
    func cancelTestButtonTap() {
        let viewControllerToPresent = TNSheetViewController()
        viewControllerToPresent.contentTableViewDataSource = ["1", "2", "3"]
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(viewControllerToPresent, animated: true)
    }
    
    @objc
    func confirmTestButtonTap() {
        TNAlert(viewController: self)
            .setTitle("setTitle")
            .setSubTitle("setSubTitle")
            .addCancelAction("취소", action: nil)
            .addConfirmAction("확인", action: nil)
            .present()
    }
    
    override func configures() {
        view.backgroundColor = .white
    }
    
    override func addSubViews() {
        view.addSubview(testButton)
        view.addSubview(cancelTestButton)
        view.addSubview(confirmTestButton)
        view.addSubview(testSwitch)
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
        
        testSwitch.pin
            .top(to: confirmTestButton.edge.bottom)
            .hCenter()
    }
}
