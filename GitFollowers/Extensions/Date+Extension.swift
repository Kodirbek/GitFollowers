//
//  Date+Extension.swift
//  GitFollowers
//
//  Created by kodirbek on 2/19/24.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
}
