//
//  DarkTheme.swift
//  WireguardApp
//
//  Created by Сергей on 25.05.2023.
//

import UIKit

class DarkTheme: ThemeProtocol {

    var backgroundColor: UIColor = Constants.COLORS.COLOR_BLACK

    var splashNameColor: UIColor = Constants.COLORS.COLOR_WHITE

    var menuImage: UIImage = UIImage(named: "menu_dark")!

    var cardImage: UIImage = UIImage(named: "card_dark")!

    var statusLightColor: UIColor = Constants.COLORS.COLOR_GRAY_DARK

    var statusDarkColor: UIColor = Constants.COLORS.COLOR_WHITE

    var timeLightColor: UIColor = Constants.COLORS.COLOR_GRAY_DARK

    var timeDarkColor: UIColor = Constants.COLORS.COLOR_WHITE

    var subscriptionColor: UIColor = Constants.COLORS.COLOR_WHITE

    var indicatorColor: CGColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)

    var buttonBackgroundColor: UIColor = Constants.COLORS.COLOR_WHITE

    var buttonTextColor: UIColor = Constants.COLORS.COLOR_BLACK

    var switchOnTintColor: UIColor = Constants.COLORS.COLOR_GREEN

    var switchOffTintColor: UIColor = Constants.COLORS.COLOR_GRAY2_DARK

    var switchThumbTintColor: UIColor = Constants.COLORS.COLOR_WHITE //COLOR_GRAY3_DARK

    var backgroundTableColor: UIColor = Constants.COLORS.COLOR_BLACK

    var backgroundTableCellColor: UIColor = Constants.COLORS.COLOR_GRAY2_DARK

    var textTableCellColor: UIColor = Constants.COLORS.COLOR_WHITE

    var backgroundNavigationBarColor: UIColor = Constants.COLORS.COLOR_BLACK

    var titleNavigationBarColor: UIColor = Constants.COLORS.COLOR_WHITE
}
