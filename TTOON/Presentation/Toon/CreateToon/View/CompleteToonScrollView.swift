//
//  CompleteToonScrollView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 8/4/24.
//
import UIKit

import RxCocoa
import RxSwift

class CompleteToonScrollView: BaseView {
    let completeToonView = CompleteToonView()
    
    private let scrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(completeToonView)
    }
    
    override func layouts() {
        scrollView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        
        completeToonView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = completeToonView.frame.size
    }   
}
