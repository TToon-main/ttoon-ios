//
//  String+.swift
//  TTOON
//
//  Created by 임승섭 on 7/19/24.
//

import Foundation

extension String {
    func toDate(to type: DateFormatType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.date(from: self)
    }
}
