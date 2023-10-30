//
//  LoadAttempt.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import UIKit

struct LoadAttempt: Codable {

    var status: String?
    var message: String?
    var days: Int?
    var button: Bool?

    private enum CodingKeys : CodingKey {
        case status, message, days, button
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        if let message = try container.decodeIfPresent(String.self, forKey: .message) {
            self.message = message
        } else {
            self.message = "N/A"
        }
        self.days = try container.decode(Int.self, forKey: .days)
        self.button = try container.decode(Bool.self, forKey: .button)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(message, forKey: .message)
        try container.encode(days, forKey: .days)
        try container.encode(button, forKey: .button)
    }

    init(status: String?, message: String?, days: Int?, button: Bool?) {
        self.status = status
        self.message = message
        self.days = days
        self.button = button
    }

    init(loadAttemptDictionary: [String: AnyObject]) {
        self.status = loadAttemptDictionary["status"] as? String
        self.message = loadAttemptDictionary["message"] as? String
        self.days = loadAttemptDictionary["days"] as? Int
        self.button = loadAttemptDictionary["button"] as? Bool
    }

}
