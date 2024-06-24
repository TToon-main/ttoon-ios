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
        view.numberOfLines = 0
        
        return view
    }()
    
    let midSubTitleLabel = {
        let view = CreateToonMidSubTitleLabel()
        view.text = "자세히 써주시면 네컷만화를\n더 정확하게 그릴 수 있어요"
        view.numberOfLines = 0
        
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
        let view = UILabel()
        view.font = .body14r
        view.textColor = .grey05
        
        return view
    }()
    
    override func addSubViews() {
        addSubview(midTitleLabel)
        addSubview(midSubTitleLabel)
        addSubview(diaryInputTextView)
        addSubview(dairyLimitTextView)
    }
    
    override func layouts() {
        midTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        midSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(midTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        diaryInputTextView.snp.makeConstraints {
            $0.top.equalTo(midSubTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(260)
        }
        
        dairyLimitTextView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(diaryInputTextView.snp.bottom).offset(4)
        }
    }
    
    override func bind() {
        diaryInputTextView.rx.text
            .filter { $0 != self.diaryInputTextView.placeholderText }
            .compactMap { $0 }
            .map{ "\($0.count)/\(self.diaryInputTextView.limitCnt)"}
            .bind(to: dairyLimitTextView.rx.text)
            .disposed(by: disposeBag)
    }
}
