//
//  Menu.swift
//  VPN
//
//  Created by Сергей on 07.05.2023.
//

import UIKit

struct Menu: Codable {

    var name: String?
    var buttons: [MenuButtons]?

    init(name: String?, buttons: [MenuButtons]?) {
        self.name = name
        self.buttons = buttons
    }

    init(menuDictionary: [String: AnyObject]) {
        self.name = menuDictionary["name"] as? String
        if (menuDictionary["buttons"] != nil) {
            var buttons = [MenuButtons]()
            let buttonsDictionaries = menuDictionary["buttons"] as! [[String: AnyObject]]
            for buttonsDictionary in buttonsDictionaries {
                let newResponses = MenuButtons(buttonsDictionary: buttonsDictionary)
                buttons.append(newResponses)
            }
            self.buttons = buttons
        }
    }

}
