//
//  BaseView.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        layouts()
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() { }
    func layouts() { }
    func configures() { }
}
