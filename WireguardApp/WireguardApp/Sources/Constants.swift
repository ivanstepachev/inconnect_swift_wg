//
//  Constants.swift
//  VPN
//
//  Created by Сергей on 28.04.2023.
//

import UIKit

struct Constants {

    struct APP {
        static let NAME = "InConnect"
        static let API_URL = "https://ntens.ru/api/"
        static let URL = "https://apps.apple.com/ru/app/inconnect/id376771144"
        static let MARKET = "itms-apps://itunes.apple.com/app/id376771144"
        static let SPLASH_SCREEN_DELAY = 1.0
    }

    struct API {
        static let LOAD = "load"
        static let CONNECT = "connect"
        static let DISCONNECT = "disconnect"
        static let MENU = "menu"
        static let PAYMENT = "payment"
        static let RECONNECT = "reconnect"
    }

    struct COLORS {
        static let COLOR_WHITE = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        static let COLOR_BLACK = UIColor(red: 0, green: 0, blue: 0, alpha: 1) //UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1)
        static let COLOR_GRAY_LIGHT = UIColor(red: 0.749, green: 0.749, blue: 0.749, alpha: 1)
        static let COLOR_GRAY2_LIGHT = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        static let COLOR_GRAY3_LIGHT = UIColor.systemGray
        static let COLOR_GRAY4_LIGHT = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1);
        static let COLOR_GRAY_DARK = UIColor(red: 0.325, green: 0.325, blue: 0.325, alpha: 1)
        static let COLOR_GRAY2_DARK = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        static let COLOR_GRAY3_DARK = UIColor(red: 0.263, green: 0.263, blue: 0.263, alpha: 1)
        static let COLOR_BLUE = UIColor.systemBlue
        static let COLOR_GREEN = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1)
        static let COLOR_RED = UIColor.red

    }

}
