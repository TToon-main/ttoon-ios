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
    
    let diaryInputTextView1 = {
        let limitCnt: Int = 150
        let placeholderText = "오늘 하루 중, 만화의 첫번째 장면에 들어갈 내용을 들려주세요."
        let view = SettingTextView(placeholderText: placeholderText,
                                   limitCnt: limitCnt)
        
        return view
    }()
    
    let dairyLimitTextView1 = {
        let view = TextStatusView()
        view.textCntLabel.text = "0"
        view.textLimitLabel.text = "/150"
        
        return view
    }()
    
    let diaryInputTextView2 = {
        let limitCnt: Int = 150
        let placeholderText = "오늘 하루 중, 만화의 두번째 장면에 들어갈 내용을 들려주세요.!"
        let view = SettingTextView(placeholderText: placeholderText,
                                   limitCnt: limitCnt)
        
        return view
    }()
    
    let dairyLimitTextView2 = {
        let view = TextStatusView()
        view.textCntLabel.text = "0"
        view.textLimitLabel.text = "/150"
        
        return view
    }()
    
    
    let diaryInputTextView3 = {
        let limitCnt: Int = 150
        let placeholderText = "오늘 하루 중, 만화의 새번째 장면에 들어갈 내용을 들려주세요."
        let view = SettingTextView(placeholderText: placeholderText,
                                   limitCnt: limitCnt)
        
        return view
    }()
    
    let dairyLimitTextView3 = {
        let view = TextStatusView()
        view.textCntLabel.text = "0"
        view.textLimitLabel.text = "/150"
        
        return view
    }()
    
    let diaryInputTextView4 = {
        let limitCnt: Int = 150
        let placeholderText = "오늘 하루 중, 만화의 네번째 장면에 들어갈 내용을 들려주세요."
        let view = SettingTextView(placeholderText: placeholderText,
                                   limitCnt: limitCnt)
        
        return view
    }()
    
    let dairyLimitTextView4 = {
        let view = TextStatusView()
        view.textCntLabel.text = "0"
        view.textLimitLabel.text = "/150"
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(midTitleLabel)
        addSubview(midSubTitleLabel)
        addSubview(diaryTitleTextField)
        addSubview(diaryInputTextView1)
        addSubview(dairyLimitTextView1)
        addSubview(diaryInputTextView2)
        addSubview(dairyLimitTextView2)
        addSubview(diaryInputTextView3)
        addSubview(dairyLimitTextView3)
        addSubview(diaryInputTextView4)
        addSubview(dairyLimitTextView4)
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
        
        diaryInputTextView1.snp.makeConstraints {
            $0.top.equalTo(diaryTitleTextField.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(216)
        }
        
        dairyLimitTextView1.snp.makeConstraints {
            $0.top.equalTo(diaryInputTextView1.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        diaryInputTextView2.snp.makeConstraints {
            $0.top.equalTo(dairyLimitTextView1.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(216)
        }
        
        dairyLimitTextView2.snp.makeConstraints {
            $0.top.equalTo(diaryInputTextView2.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        diaryInputTextView3.snp.makeConstraints {
            $0.top.equalTo(dairyLimitTextView2.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(216)
        }
        
        dairyLimitTextView3.snp.makeConstraints {
            $0.top.equalTo(diaryInputTextView3.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        diaryInputTextView4.snp.makeConstraints {
            $0.top.equalTo(dairyLimitTextView3.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(216)
        }
        
        dairyLimitTextView4.snp.makeConstraints {
            $0.top.equalTo(diaryInputTextView4.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview()
        }
    }
}
