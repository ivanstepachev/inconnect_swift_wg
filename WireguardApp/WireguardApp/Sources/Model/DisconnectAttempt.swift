//
//  DisconnectAttempt.swift
//  VPN
//
//  Created by Сергей on 02.05.2023.
//

import UIKit

class DisconnectAttempt {

    var status: String?
    var message: String?

    init(status: String?, message: String?) {
        self.status = status
        self.message = message
    }

    init(disconnectAttemptDictionary: [String: AnyObject]) {
        self.status = disconnectAttemptDictionary["status"] as? String
        self.message = disconnectAttemptDictionary["message"] as? String
    }

}
