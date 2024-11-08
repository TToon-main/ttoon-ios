//
//  TNAlertViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/11/24.
//

import Foundation

class TNAlertViewController: BaseViewController {
    var titleMessage: String?
    var subTitleMessage: String?
    var cancelAction: AlertButtonAction?
    var confirmAction: AlertButtonAction?
    
    let alertView = TNAlertView()
    
    override func loadView() {
        super.loadView()
        view = alertView
    }
    
    override func layouts() {
        view.pin.all()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        alertView.container.pin
            .horizontally(24)
            .vCenter()
        
        alertView.container.flex.layout(mode: .adjustHeight)
    }
    
    override func configures() {
        setAlert()
        addTarget()
    }
    
    private func setAlert() {
        alertView.titleMessage.text = titleMessage
        alertView.subTitleMessage.text = subTitleMessage
        alertView.cancelButton.setTitle(cancelAction?.text, for: .normal)
        alertView.confirmButton.setTitle(confirmAction?.text, for: .normal)
        
        if subTitleMessage == nil {
            alertView.subTitleFlexItem?.marginTop(0)
        }
    }
    
    private func addTarget() {
        alertView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        alertView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        cancelAction?.action?()
        dismiss(animated: true)
    }
    
    @objc func confirmButtonTapped() {
        confirmAction?.action?()
        dismiss(animated: true)
    }
}
