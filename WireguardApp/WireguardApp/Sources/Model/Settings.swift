//
//  Settings.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import UIKit

class Settings {

    var header: String?
    var name: [String]?
    var value: [String]?
    var url: [String]?
    var copy: [Bool]?

    init(header: String?, name: [String]?, value: [String]?, url: [String]?, copy: [Bool]?) {
        self.header = header
        self.name = name
        self.value = value
        self.url = url
        self.copy = copy
    }

    init(settingsDictionary: [String: AnyObject]) {
        self.header = settingsDictionary["header"] as? String
        self.name = settingsDictionary["name"] as? [String]
        self.value = settingsDictionary["value"] as? [String]
        self.url = settingsDictionary["url"] as? [String]
        self.copy = settingsDictionary["copy"] as? [Bool]
    }

}
