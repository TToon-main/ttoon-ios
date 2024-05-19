//
//  SettingTitleLabel.swift
//  TTOON
//
//  Created by 임승섭 on 5/18/24.
//

import UIKit

// 세팅 화면에서 텍스트필드, 텍스트뷰의 이름으로 들어가는 레이블

class SettingTitleLabel: UILabel {
    convenience init(_ text: String) {
        self.init()
        
        self.text = text
        self.textColor = .grey06
        self.font = .body14m
    }
}
