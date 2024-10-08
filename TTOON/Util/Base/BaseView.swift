//
//  BaseView.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit

class BaseView: UIView {
    var height = UIScreen.main.bounds.height
    var width = UIScreen.main.bounds.width
    lazy var safeGuide = safeAreaLayoutGuide
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        bind()
        layouts()
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() { }
    func layouts() { }
    func configures() { 
        self.backgroundColor = .white
    }
    
    func bind() {
    }
}
