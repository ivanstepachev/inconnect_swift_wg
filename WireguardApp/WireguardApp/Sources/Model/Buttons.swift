//
//  Buttons.swift
//  VPN
//
//  Created by Сергей on 06.05.2023.
//

import UIKit

struct Buttons: Codable {

    var title: String?
    var url: String?

    init(title: String?, url: String?) {
        self.title = title
        self.url = url
    }

    init(buttonsDictionary: [String: AnyObject]) {
        self.title = buttonsDictionary["title"] as? String
        self.url = buttonsDictionary["url"] as? String
    }

}
