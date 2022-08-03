//
//  Date+Extension.swift
//  Weather
//
//  Created by Tony on 03/08/2022.
//  Copyright © 2022 Tony. All rights reserved.
//

import Foundation

extension Int {
    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
}
