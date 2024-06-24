//
//  CreateToonBaseViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

class CreateToonBaseViewController: BaseViewController {
    private let progressBar = {
        let view = UIProgressView()
        view.progress = 0.5
        view.progressTintColor = .tnOrange
        
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        view.addSubview(progressBar)
    }
    
    override func configures() {
        super.configures()
        setNavigationItem()
    }
    
    override func layouts() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(safeGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    private func setNavigationItem() {
        self.navigationItem.title = "기록 추가하기"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}
