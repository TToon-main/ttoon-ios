//
//  FeedDetailMenuBottomSheetView.swift
//  TTOON
//
//  Created by 임승섭 on 9/25/24.
//

import UIKit

class FeedDetailMenuBottomSheetView: BaseView {
    // 버튼 3개, 디바이더 2개
    lazy var firstButton = makeButton(false)
    lazy var secondButton = makeButton(false)
    lazy var thirdButton = makeButton(true)
    
    lazy var firstDivider = makeDivider()
    lazy var secondDivider = makeDivider()
    
    override func addSubViews() {
        super.addSubViews()
        
        [firstButton, secondButton, thirdButton, firstDivider, secondDivider].forEach {
            self.addSubview($0)
        }
    }
    
    override func layouts() {
        super.layouts()
        
        // 높이 60. 위아래 패딩 15씩
        firstButton.snp.makeConstraints { make in
            make.top.equalTo(self).inset(15)
            make.height.equalTo(60)
            make.horizontalEdges.equalTo(self).inset(20)
        }
        
        firstDivider.snp.makeConstraints { make in
            make.top.equalTo(firstButton.snp.bottom)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(self).inset(20)
        }
        
        secondButton.snp.makeConstraints { make in
            make.top.equalTo(firstDivider.snp.bottom)
            make.height.equalTo(60)
            make.horizontalEdges.equalTo(self).inset(20)
        }
        
        secondDivider.snp.makeConstraints { make in
            make.top.equalTo(secondButton.snp.bottom)
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(self).inset(20)
        }
        
        thirdButton.snp.makeConstraints { make in
            make.top.equalTo(secondDivider.snp.bottom)
            make.height.equalTo(60)
            make.horizontalEdges.equalTo(self).inset(20)
            make.bottom.equalTo(self).inset(15)
        }
    }
}

extension FeedDetailMenuBottomSheetView {
    func setText(first: String, second: String, third: String) {
        firstButton.setTitle(first, for: .normal)
        secondButton.setTitle(second, for: .normal)
        thirdButton.setTitle(third, for: .normal)
    }
}

extension FeedDetailMenuBottomSheetView {
    private func makeButton(_ redText: Bool) -> UIButton {
        let view = UIButton()
        view.setTitleColor(redText ? .red : .black, for: .normal)
        view.setTitle("이미지 저장하기", for: .normal)
        view.titleLabel?.font = .body16m
        view.contentHorizontalAlignment = .left
        return view
    }
    
    private func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#E8E8E8")
        return view
    }
}
