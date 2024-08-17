//
//  CharacterDeleteBSView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 7/14/24.
//

import UIKit

import RxSwift

class CharacterDeleteBSView: BaseView {
    let titleLabel = {
        let view = CreateToonMidTitleLabel()
        
        return view
    }()
    
    let subTitleLabel = {
        let view = CreateToonSubTitleLabel()
        view.text = "캐릭터를 삭제하면, 기존에 입력해둔\n내용을 다시 복구할 수 없어요"
        
        return view
    }()
    
    let trashImageView = {
        let view = UIImageView() 
        view.image = TNImage.characterDeleteIcon
        
        return view
    }()
    
    let backButton = {
        let view = TNAlertButton()
        view.setTitle("돌아가기", for: .normal)
        view.type = .cancel
        
        return view
    }()
    
    let confirmButton = {
        let view = TNButton()
        view.setTitle("삭제할래요", for: .normal)
        
        return view
    }()
    
    lazy var buttonStack = {
        let view = UIStackView() 
        view.addArrangedSubview(backButton)
        view.addArrangedSubview(confirmButton)
        view.spacing = 11
        view.distribution = .fillEqually
        
        return view
    }()
    
    override func configures() {
        super.configures()
        layer.cornerRadius = 25
    }
    
    override func addSubViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(trashImageView)
        addSubview(buttonStack)
    }
    
    override func layouts() {
        titleLabel.snp.makeConstraints { 
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(44)
        }
        
        subTitleLabel.snp.makeConstraints { 
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        trashImageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
}

extension Reactive where Base: CharacterDeleteBSView {
    var deleteButtonTap: Observable<CharacterDeleteBSReactor.Action> {
        return base.confirmButton.rx.tap
            .map { CharacterDeleteBSReactor.Action.deleteButtonTap }
    }
    
    var backButtonTap: Observable<CharacterDeleteBSReactor.Action> {
        return base.backButton.rx.tap
            .map { CharacterDeleteBSReactor.Action.backButtonTap }
    }
    
    var userName: Binder<String> {
        return Binder(base) { view, text in
            view.titleLabel.text = "‘\(text)’ 캐릭터를\n정말 삭제하시겠어요?"
        }
    }
}
