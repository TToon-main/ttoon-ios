//
//  AlarmViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/20/24.
//

import UIKit

import RxCocoa
import RxSwift

final class AlarmViewController: BaseViewController {
    // MARK: - Properties
    
    weak var delegate: ReloadMyPageDataSource?

    // MARK: - UI Properties
    
    let alarmView = AlarmView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        super.loadView()
        view = alarmView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setIsAlarmEnabled()
        delegate?.reload()
    }
    
    // MARK: - Method
    
    private func setIsAlarmEnabled() {
        let isAlarmEnabled = alarmView.alarmSwitch.isOn
        KeychainStorage.shared.isAlarmEnabled = isAlarmEnabled
    }
}
