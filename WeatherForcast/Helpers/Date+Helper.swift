//
//  Date+Helper.swift
//  WeatherForcast
//
//  Created by Armando D Gonzalez on 1/15/19.
//  Copyright © 2019 Armando D Gonzalez. All rights reserved.
//

import Foundation

extension Date {
    static func tomorrowDateString() -> String {
        var dateComponent = DateComponents()
        dateComponent.setValue(1, for: .day);
        let today = Date()
        let tomorrowsDate = Calendar.current.date(byAdding: dateComponent, to: today)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let tomorrowsDate = tomorrowsDate {
            return dateFormatter.string(from: tomorrowsDate)
        } else {
            print("Unable to get tomorrows date.")
            return dateFormatter.string(from: Date())
        }
    }
}
