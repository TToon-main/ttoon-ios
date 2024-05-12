//
//  ResponseDTO.swift
//  TTOON
//
//  Created by 임승섭 on 5/13/24.
//

import Foundation

// 서버 응답 성공 (데이터 존재 o)
struct ResponseSuccessDTO<T: Codable>: Codable {
    
    let isSuccess: Bool
    let code: String
    let message: String
    let data: T
}


// 서버 응답 성공 (데이터 존재 x) or 서버 응답 실패
struct ResponseWithNoDataDTO: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}

// data: T? 로 해서 두 구조체를 하나로 만드는 것보다, 둘로 분리하는게 더 낫다고 생각.
