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
        dateFormatter.dateFormat = type.rawValue
        
        if let locale = type.locale {
            dateFormatter.locale = type.locale
        }
        
        return dateFormatter.string(from: self)
    }
}
