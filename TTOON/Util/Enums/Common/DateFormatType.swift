//
//  DateFormatType.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import Foundation

enum DateFormatType: String {
    case fulldate = "yyyy/M/d" // 날짜 비교 시 해당 문자열로 비교
    
    case yearMonthKorean = "yyyy년 M월"
    case fullKorean = "yyyy년 M월 d일"
    
    case fullWithHyphen = "yyyy-MM-dd"
    case yearMonthWithHyphen = "yyyy-MM"
    
    case fullWithDot = "yyyy.MM.dd"
}
