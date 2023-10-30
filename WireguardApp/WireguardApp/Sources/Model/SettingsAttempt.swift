//
//  SettingsAttempt.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import UIKit

struct SettingsAttempt: Codable {

    var menu: [Menu]?
    var button: Bool?

    private enum CodingKeys : CodingKey {
        case menu, button
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.menu = try container.decodeIfPresent([Menu].self, forKey: .menu)
        self.button = try container.decode(Bool.self, forKey: .button)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(menu, forKey: .menu)
        try container.encode(button, forKey: .button)
    }

    init(menu: [Menu]?, button: Bool?) {
        self.menu = menu
        self.button = button
    }

    init(settingsAttemptDictionary: [String: AnyObject]) {
        if (settingsAttemptDictionary["menu"] != nil) {
            var menu = [Menu]()
            let menuDictionaries = settingsAttemptDictionary["menu"] as! [[String: AnyObject]]
            for menuDictionary in menuDictionaries {
                let newResponses = Menu(menuDictionary: menuDictionary)
                menu.append(newResponses)
            }
            self.menu = menu
        }
        self.button = settingsAttemptDictionary["button"] as? Bool
    }
}
