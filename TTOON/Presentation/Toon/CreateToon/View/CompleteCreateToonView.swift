//
//  CompleteCreateToonView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 11/3/24.
//

import UIKit

import RxCocoa
import RxSwift

class CompleteCreateToonView: BaseView {
    private let titleLabel = {
        let view = UILabel()
        view.font = .title24b
        view.textColor = .black
        view.text = "만화 생성이 완료되었어요!"
        view.numberOfLines = 0
        
        return view
    }()
    
    private let subTitleLabel = {
        let view = UILabel()
        view.font = .body16m
        view.textColor = .grey06
        view.text = "조혜원님이 써주신 일기를\n바탕으로 네컷만화를 그렸어요"
        view.numberOfLines = 0
        
        return view
    }()
    
    private let imageView = {
        let view = UIImageView()
        view.image = TNImage.completeToonIcon
        
        return view
    }()
    
    fileprivate let confirmButton = {
        let view = TNButton()
        view.setTitle("생성된 만화 보러가기", for: .normal)
        
        return view
    }()
    
    override func addSubViews() {
        [titleLabel, subTitleLabel, imageView, confirmButton].forEach { v in
            addSubview(v)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeGuide).offset(52)
            $0.leading.equalTo(safeGuide).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(safeGuide).offset(16)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(135)
            $0.width.equalTo(217.97)
            $0.height.equalTo(216.31)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.bottom.equalTo(safeGuide).offset(-36)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
 

extension Reactive where Base: CompleteCreateToonView {
    var confirmButtonTap: Observable<Void> {
        return base.confirmButton.rx.tap.asObservable()
    }
}
