//
//  Theme.swift
//  WireguardApp
//
//  Created by Сергей on 25.05.2023.
//

import UIKit

protocol ThemeProtocol {

    var backgroundColor: UIColor { get }

    var splashNameColor: UIColor { get }

    var menuImage: UIImage { get }

    var cardImage: UIImage { get }

    var statusLightColor: UIColor { get }

    var statusDarkColor: UIColor { get }

    var timeLightColor: UIColor { get }

    var timeDarkColor: UIColor { get }

    var subscriptionColor: UIColor { get }

    var indicatorColor: CGColor { get }

    var buttonBackgroundColor: UIColor { get }

    var buttonTextColor: UIColor { get }

    var switchOnTintColor: UIColor { get }

    var switchOffTintColor: UIColor { get }

    var switchThumbTintColor: UIColor { get }

    var backgroundTableColor: UIColor { get }

    var backgroundTableCellColor: UIColor { get }

    var textTableCellColor: UIColor { get }

    var backgroundNavigationBarColor: UIColor { get }

    var titleNavigationBarColor: UIColor { get }

}

class Theme {

    static var currentTheme: ThemeProtocol = LightTheme()

}
