//
//  ResponseDTO.swift
//  TTOON
//
//  Created by 임승섭 on 5/13/24.
//

import Foundation

// 서버 응답 성공 (데이터 존재 o)
struct ResponseDTO<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let data: T?
}
