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
    
    func toDomain() -> AttendanceStatus {
        let weekAttendance = fetchIsAttendance(self.dayStatus)
        let isTodayAttendance = isTodayAttendance(self.dayStatus)
        
        
        return .init(point: point,
                     weekAttendance: weekAttendance,
                     isTodayAttendance: isTodayAttendance)
    }
}

extension GetAttendanceResponseDTO {
    private func fetchIsAttendance(_ days: [GetAttendanceResponseDTO.DayStatus]) -> [Bool] {
        return days.map { attendance in
            attendance.isAttended
        }
    }

    private func isTodayAttendance(_ days: [GetAttendanceResponseDTO.DayStatus]) -> Bool {
        let today = Date().toString(of: .onlyDay).uppercased()
        
        let todayStatus = days
            .filter { $0.day == today  }
            .map { $0.isAttended }
        
        let isEnabled = todayStatus
            .map { !$0 }.first
            
        return isEnabled ?? false
    }
}
