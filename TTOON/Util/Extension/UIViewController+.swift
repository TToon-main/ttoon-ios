//
//  UIViewController+.swift
//  TTOON
//
//  Created by 임승섭 on 7/7/24.
//

import UIKit

extension UIViewController {
    // 키보드 내리기
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
