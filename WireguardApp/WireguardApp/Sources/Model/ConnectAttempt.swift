//
//  ConnectAttempt.swift
//  VPN
//
//  Created by Сергей on 02.05.2023.
//

import UIKit

class ConnectAttempt {

    var status: String?
    var message: String?
    var privatekey: String?
    var address: String?
    var dns: String?
    var publickey: String?
    var endpoint: String?
    var allowed_ips: String?
    var pers_keep_alive: Int?

    init(status: String?, message: String?, privatekey: String?, address: String?, dns: String?, publickey: String?, endpoint: String?, allowed_ips: String?, pers_keep_alive: Int?) {
        self.status = status
        self.message = message
        self.privatekey = privatekey
        self.address = address
        self.dns = dns
        self.publickey = publickey
        self.endpoint = endpoint
        self.allowed_ips = allowed_ips
        self.pers_keep_alive = pers_keep_alive
    }

    init(connectAttemptDictionary: [String: AnyObject]) {
        self.status = connectAttemptDictionary["status"] as? String
        self.message = connectAttemptDictionary["message"] as? String
        self.privatekey = connectAttemptDictionary["privatekey"] as? String
        self.address = connectAttemptDictionary["address"] as? String
        self.dns = connectAttemptDictionary["dns"] as? String
        self.publickey = connectAttemptDictionary["publickey"] as? String
        self.endpoint = connectAttemptDictionary["endpoint"] as? String
        self.allowed_ips = connectAttemptDictionary["allowed_ips"] as? String
        self.pers_keep_alive = connectAttemptDictionary["pers_keep_alive"] as? Int
    }

}
