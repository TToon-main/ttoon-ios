//
//  FeedDetailMenuBottomSheetViewController.swift
//  TTOON
//
//  Created by 임승섭 on 9/25/24.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

// 재사용할 수 있기 때문에, reactor를 전달받는 방법은 좋지 않다고 판단
class FeedDetailMenuBottomSheetViewController: BaseViewController {
    var disposeBag = DisposeBag()
    
    let menuView = FeedDetailMenuBottomSheetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonBind()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(menuView)
    }
    
    override func layouts() {
        super.layouts()
        
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(36)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func configures() {
        super.configures()
        
        menuView.clipsToBounds = true
        menuView.layer.cornerRadius = 25
    }
}

// private func
extension FeedDetailMenuBottomSheetViewController {
    private func setButtonBind() {
        [menuView.firstButton, menuView.secondButton, menuView.thirdButton].forEach{
            $0.rx.tap
                .subscribe(with: self) { owner, _ in
                    self.dismiss(animated: true)
                }
                .disposed(by: disposeBag)
        }
    }
}
