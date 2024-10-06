//
//  CreateToonDiaryView.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 6/22/24.
//

import UIKit

import RxCocoa
import RxSwift

class CreateToonDiaryView: BaseView {
    private let disposeBag = DisposeBag()
    
    let midTitleLabel = {
        let view = CreateToonMidTitleLabel()
        view.text = "일기 작성"
        
        return view
    }()
    
    let midSubTitleLabel = {
        let view = CreateToonMidSubTitleLabel()
        view.text = "자세히 써주시면 네컷만화를\n더 정확하게 그릴 수 있어요"
        view.numberOfLines = 0
        
        return view
    }()
    
    let diaryTitleTextField = {
        let view = TNTextFiled()
        view.textFiled.placeholder = "제목을 입력해주세요"
        view.statusLabel.textCntLabel.text = "0"
        view.statusLabel.textLimitLabel.text = "/20"
        
        return view
    }()
    
    let diaryInputTextView = {
        let limitCnt: Int = 200
        let placeholderText = "오늘 하루에 대해 자세히 들려주세요!"
        let view = SettingTextView(placeholderText: placeholderText,
                                   limitCnt: limitCnt)
        
        return view
    }()
    
    let dairyLimitTextView = {
        let view = TextStatusView()
        view.textCntLabel.text = "0"
        view.textLimitLabel.text = "/200"
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(midTitleLabel)
        addSubview(midSubTitleLabel)
        addSubview(diaryTitleTextField)
        addSubview(diaryInputTextView)
        addSubview(dairyLimitTextView)
    }
    
    override func layouts() {
        midTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(27)
        }
        
        midSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(midTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        diaryTitleTextField.snp.makeConstraints {
            $0.top.equalTo(midSubTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(76)
        }
        
        diaryInputTextView.snp.makeConstraints {
            $0.top.equalTo(diaryTitleTextField.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(260)
        }
        
        dairyLimitTextView.snp.makeConstraints {
            $0.top.equalTo(diaryInputTextView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview()
        }
    }
}
