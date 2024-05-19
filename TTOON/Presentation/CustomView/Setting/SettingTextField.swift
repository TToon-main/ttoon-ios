//
//  SettingTextField.swift
//  TTOON
//
//  Created by 임승섭 on 5/18/24.
//


import RxSwift
import SnapKit
import UIKit

class SettingTextField: UITextField {
    private let disposeBag = DisposeBag()
    
    convenience init(_ placeholderText: String) {
        self.init()
        
        setUp(placeholderText)
        bind()
    }
    
    // clearButton 위치 조정하기 위한 오버라이딩
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -8, dy: 0)
    }
    
    private func setUp(_ placeholderText: String) {
        // left padding
        addLeftPadding()
        
        // clear Button
        self.clearButtonMode = .whileEditing
        
        // placeholder
        self.placeholder = placeholderText
        
        // background
        self.backgroundColor = .grey01
        
        // border
        self.clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func bind() {
        self.rx.text
            .subscribe(with: self) { owner, value in
                if value!.isEmpty {
                    owner.layer.borderColor = UIColor.clear.cgColor
                }
                else {
                    if owner.isValidEmail(value) {
                        owner.layer.borderColor = UIColor.clear.cgColor
                    } else {
                        owner.layer.borderColor = UIColor(hexString: "#FF6666")?.cgColor
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SettingTextField {
    // 이메일 유효성 검증
    private func isValidEmail(_ text: String?) -> Bool {
        guard let text = text else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        print("hi : ", emailTest.evaluate(with: text))
        return emailTest.evaluate(with: text)
    }
    
    // 좌우 패딩
    private func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
