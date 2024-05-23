//
//  TNSwitch.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 5/11/24.
//


import UIKit

import RxCocoa
import RxSwift

class TNSwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        onTintColor = .tnOrange
    }
}
