//
//  UIButton+.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/27/24.
//

import UIKit

extension UIButton {
    /// leadingInset:  leading 값
    /// spacing: title과 image의 간격
    /// semanticAttribute: title과 image의 정렬 방식
    
    func configureButtonLayout(leadingInset: CGFloat = 0, spacing: CGFloat, semanticAttribute: UISemanticContentAttribute = .forceLeftToRight) {
        self.semanticContentAttribute = semanticAttribute
        
        let imageInset = spacing / 2
        let titleInset = -imageInset + leadingInset
        
        if semanticAttribute == .forceRightToLeft {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageInset, bottom: 0, right: -imageInset)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -titleInset)
        } else {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageInset, bottom: 0, right: imageInset)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -titleInset, bottom: 0, right: titleInset)
        }
        
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: leadingInset, bottom: 0, right: leadingInset)
    }
}
