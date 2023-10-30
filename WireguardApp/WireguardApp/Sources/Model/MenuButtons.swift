//
//  MenuButtons.swift
//  VPN
//
//  Created by Сергей on 07.05.2023.
//

import UIKit

struct MenuButtons: Codable {

    var title: String?
    var value: String?
    var url: String?
    var copy_value: Bool?

    init(title: String?, value: String?, url: String?, copy_value: Bool?) {
        self.title = title
        self.value = value
        self.url = url
        self.copy_value = copy_value
    }

    init(buttonsDictionary: [String: AnyObject]) {
        self.title = buttonsDictionary["title"] as? String
        self.value = buttonsDictionary["value"] as? String
        self.url = buttonsDictionary["url"] as? String
        self.copy_value = buttonsDictionary["copy_value"] as? Bool
    }

}
