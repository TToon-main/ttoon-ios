//
//  Date+.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import Foundation

extension Date {
    func toString(of type: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
}
