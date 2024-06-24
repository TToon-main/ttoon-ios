//
//  EnterInfoViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

import RxCocoa
import RxSwift

class EnterInfoViewController: CreateToonBaseViewController {
    private let disposeBag = DisposeBag()
    
    private let scrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        
        return view
    }()
    
    private let enterInfoView = EnterInfoView()
    
    override func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(enterInfoView)
    }
    
    override func layouts() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        enterInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
