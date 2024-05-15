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
        view.setTitle("disabled", for: .normal)
        view.isEnabled = false
        
        return view
    }()
    
    private lazy var testButton2 = {
        let view = TNButton()
        view.setTitle("enabled", for: .normal)
        
        return view
    }()
    
    private lazy var sheetButton = {
        let view = TNAlertButton()
        view.setTitle("바텀 시트", for: .normal)
        view.type = .cancel
        view.addTarget(self, action: #selector(sheetButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var alertButton = {
        let view = TNAlertButton()
        view.setTitle("얼럿", for: .normal)
        view.type = .confirm
        view.addTarget(self, action: #selector(alertButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var testSwitch = {
        let view = TNSwitch()
        
        return view
    }()
    
    @objc
    func sheetButtonTap() {
        TNBottomSheet(self)
            .setTitle("타이틀")
            .setHeight(490)
            .setDataSource(["예시1", "예시2", "예시3", "예시4", "예시5"])
            .setSelectedIndex(3)
            .isHiddenConfirmBtn(true)
            .present()
    }
    
    @objc
    func alertButtonTap() {
        TNAlert(self)
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
        view.addSubview(testButton2)
        view.addSubview(sheetButton)
        view.addSubview(alertButton)
        view.addSubview(testSwitch)
    }
    
    override func layouts() {
        testButton.pin
            .center()
            .width(343)
            .height(56)
        
        testButton2.pin
            .top(to: testButton.edge.bottom)
            .hCenter()
            .width(343)
            .height(56)
        
        sheetButton.pin
            .top(to: testButton2.edge.bottom)
            .hCenter()
            .width(141)
            .height(56)
        
        alertButton.pin
            .top(to: sheetButton.edge.bottom)
            .hCenter()
            .width(141)
            .height(56)
        
        testSwitch.pin
            .top(to: alertButton.edge.bottom)
            .hCenter()
    }
}
