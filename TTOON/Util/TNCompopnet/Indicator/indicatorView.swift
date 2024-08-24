//
//  indicatorView.swift
//  TTOON
//
//  Created by 임승섭 on 8/23/24.
//

import UIKit

class IndicatorView: BaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(hexString: "#E8E8E8")
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
