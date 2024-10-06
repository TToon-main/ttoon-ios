//
//  CreateToonBaseViewController.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/21/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class CreateToonBaseViewController: BaseViewController {
    // MARK: - Properties
    
    lazy var orangeProgressDefaultWidth = width - 36
    var orangeProgressWidthConstraint: Constraint?
    var greyProgressWidthConstraint: Constraint?
    
    // MARK: - UI Properties
    
    let orangeProgressBar = {
        let view = UIProgressView()
        view.progress = 1.0
        view.progressTintColor = .tnOrange
        
        return view
    }()
    
    let greyProgressBar = {
        let view = UIProgressView()
        view.progress = 1.0
        view.progressTintColor = .bgGrey
        
        return view
    }()
    
    lazy var progressContainer = {
        let view = UIStackView()
        view.addArrangedSubview(orangeProgressBar)
        view.addArrangedSubview(greyProgressBar)
        view.spacing = 4
        
        return view
    }()
    
    // MARK: - Configurations
    
    override func addSubViews() {
        super.addSubViews()
        view.addSubview(progressContainer)
    }
    
    override func layouts() {
        progressContainer.snp.makeConstraints {
            $0.top.equalTo(safeGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(4)
        }
        
        orangeProgressBar.snp.makeConstraints {
            orangeProgressWidthConstraint = $0.width.equalTo(10).constraint
        }
    }
    
    func setNavigationItem(title: String) {
        self.navigationItem.title = title
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension Reactive where Base: CreateToonBaseViewController {
    var currentProgress: Binder<Float> {
        return Binder(base) { vc, progress in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                let isHiddenGreyBar = progress == 1.0
                vc.greyProgressBar.isHidden = isHiddenGreyBar
                
                let width = vc.orangeProgressDefaultWidth * CGFloat(progress)
                vc.orangeProgressWidthConstraint?.update(offset: width)
                
                vc.view.layoutIfNeeded()
            }
        }
    }
}
