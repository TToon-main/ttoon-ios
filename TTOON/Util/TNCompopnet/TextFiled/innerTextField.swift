//
//  innerTextField.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/31/24.
//

import UIKit

class InnerTextField: UITextField {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: .zero, height: 52)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .grey01
        tintColor = .tnOrange
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        
        addLeftPadding(20)
        setPlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPlaceholder() {
        guard let placeholder else { return }
        let placeholderFont = UIFont.body16m
        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont,
            .foregroundColor: UIColor.grey06
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
}
