//
//  Date.swift
//  WireguardApp
//
//  Created by Сергей on 18.05.2023.
//

import UIKit

extension Date {

    func offsetFrom(date: Date) -> String {
        let dateFormater = DateComponentsFormatter()
        dateFormater.allowedUnits = [.minute,.hour,.second]
        dateFormater.unitsStyle = .positional
        dateFormater.zeroFormattingBehavior = .pad
        let hourMinuteSecond: Set<Calendar.Component> = [.hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(hourMinuteSecond, from: date, to: self)
        let array = [difference.hour, difference.minute, difference.second]
        var n = 3600
        let seconds = array.reduce(0) {
            defer { n /= 60 }
            return $0 + $1! * n
        }
        return dateFormater.string(from: TimeInterval(seconds))!
    }

}
