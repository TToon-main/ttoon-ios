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

// 홈화면에 있는 TToonLog 커스텀 네비게이션 바 세팅
extension UIViewController {
    func setTToonLogHomeNavigation(_ view: TToonLogHomeNavigationView) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let navHeight = navigationBar.frame.size.height
        let navWidth = navigationBar.frame.size.width
        
        view.snp.makeConstraints { make in
            make.width.equalTo(navWidth)
            make.height.equalTo(navHeight)
        }
        navigationItem.titleView = view
    }
}
