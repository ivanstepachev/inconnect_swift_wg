//
//  Int.swift
//  WireguardApp
//
//  Created by Сергей on 16.05.2023.
//

import UIKit

extension Int {

     func days() -> String {
         var dayString: String!
         if "1".contains("\(self % 10)") { dayString = "\(NSLocalizedString("DAY", comment: ""))" }
         if "234".contains("\(self % 10)") { dayString = "\(NSLocalizedString("DAYS1", comment: ""))" }
         if "567890".contains("\(self % 10)") { dayString = "\(NSLocalizedString("DAYS2", comment: ""))" }
         if 11...14 ~= self % 100                   { dayString = "\(NSLocalizedString("DAYS2", comment: ""))" }
         return "\(self) " + dayString
    }
}
