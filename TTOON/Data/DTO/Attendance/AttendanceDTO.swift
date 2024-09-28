//
//  AttendanceDTO.swift
//  TTOON
//
//  Created by Dongwan Ryoo on 9/22/24.
//

import Foundation

// 출석 체크 조회 API

struct GetAttendanceResponseDTO: Codable {
    let point: Int
    let dayStatus: [DayStatus]
    
    struct DayStatus: Codable {
        let day: String
        let isAttended: Bool
        
        enum CodingKeys: String, CodingKey {
            case day = "dayOfWeek"
            case isAttended = "status"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case point
        case dayStatus = "attendanceDtoList"
    }
}
