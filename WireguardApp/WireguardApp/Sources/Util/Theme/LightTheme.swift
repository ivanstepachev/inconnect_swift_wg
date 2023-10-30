//
//  LightTheme.swift
//  WireguardApp
//
//  Created by Сергей on 25.05.2023.
//

import UIKit

class LightTheme: ThemeProtocol {

    var backgroundColor: UIColor = Constants.COLORS.COLOR_WHITE

    var splashNameColor: UIColor = Constants.COLORS.COLOR_BLACK

    var menuImage: UIImage = UIImage(named: "menu_light")!

    var cardImage: UIImage = UIImage(named: "card_light")!

    var statusLightColor: UIColor = Constants.COLORS.COLOR_GRAY_LIGHT

    var statusDarkColor: UIColor = Constants.COLORS.COLOR_BLACK

    var timeLightColor: UIColor = Constants.COLORS.COLOR_GRAY_LIGHT

    var timeDarkColor: UIColor = Constants.COLORS.COLOR_BLACK

    var subscriptionColor: UIColor = Constants.COLORS.COLOR_BLACK

    var indicatorColor: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)

    var buttonBackgroundColor: UIColor = Constants.COLORS.COLOR_BLACK

    var buttonTextColor: UIColor = Constants.COLORS.COLOR_WHITE

    var switchOnTintColor: UIColor = Constants.COLORS.COLOR_GREEN

    var switchOffTintColor: UIColor = Constants.COLORS.COLOR_GRAY2_LIGHT

    var switchThumbTintColor: UIColor = Constants.COLORS.COLOR_WHITE

    var backgroundTableColor: UIColor = Constants.COLORS.COLOR_GRAY4_LIGHT //COLOR_GRAY2_LIGHT

    var backgroundTableCellColor: UIColor = Constants.COLORS.COLOR_WHITE

    var textTableCellColor: UIColor = Constants.COLORS.COLOR_BLACK

    var backgroundNavigationBarColor: UIColor = Constants.COLORS.COLOR_WHITE

    var titleNavigationBarColor: UIColor = Constants.COLORS.COLOR_BLACK

}
