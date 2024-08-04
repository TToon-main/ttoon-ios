//
//  CreateToonBaseViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

class CreateToonBaseViewController: BaseViewController {
    let progressBar = {
        let view = UIProgressView()
        view.progress = 0.5
        view.progressTintColor = .tnOrange
        
        return view
    }()
    
    override func addSubViews() {
        super.addSubViews()
        view.addSubview(progressBar)
    }
    
    override func layouts() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(safeGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    func setNavigationItem(title: String) {
        self.navigationItem.title = title
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}
