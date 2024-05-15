//
//  TNAlert.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/11/24.
//

import UIKit

struct AlertButtonAction {
    var text: String?
    var action: (() -> Void)?
}

final class TNAlert {
    private var titleMessage: String?
    private var subTitleMessage: String?
    private var cancelAction: AlertButtonAction?
    private var confirmAction: AlertButtonAction?
    
    private let baseViewController: UIViewController
    private let alertViewController = TNAlertViewController()
    
    init(_ viewController: UIViewController) {
        baseViewController = viewController
    }

    func setTitle(_ text: String) -> Self {
        self.titleMessage = text
        return self
    }
    
    func setSubTitle(_ text: String) -> Self {
        self.subTitleMessage = text
        return self
    }
    
    func addCancelAction(_ text: String, action: (() -> Void)? = nil) -> Self {
        self.cancelAction = AlertButtonAction(text: text, action: action)
        alertViewController.alertView.cancelButton.isHidden = false
        return self
    }
    
    func addConfirmAction(_ text: String, action: (() -> Void)? = nil) -> Self {
        self.confirmAction = AlertButtonAction(text: text, action: action)
        alertViewController.alertView.confirmButton.isHidden = false
        return self
    }
    
    @discardableResult
    func present() -> Self {
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        
        alertViewController.titleMessage = titleMessage
        alertViewController.subTitleMessage = subTitleMessage
        alertViewController.confirmAction = confirmAction
        alertViewController.cancelAction = cancelAction
        baseViewController.present(alertViewController, animated: true)
        return self
    }
}
