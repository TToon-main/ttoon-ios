//
//  CreateToonDivider.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

class CreateToonDivider: BaseView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 12)
    }
    
    override func configures() {
        backgroundColor = .grey01
    }
}
