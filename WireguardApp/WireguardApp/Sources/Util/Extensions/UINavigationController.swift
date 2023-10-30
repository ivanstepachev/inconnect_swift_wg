//
//  UINavigationController.swift
//  WireguardApp
//
//  Created by Сергей on 02.06.2023.
//

import UIKit

extension UINavigationController {

    static public func navBarHeight() -> CGFloat {
       let nVc = UINavigationController(rootViewController: UIViewController(nibName: nil, bundle: nil))
       let navBarHeight = nVc.navigationBar.frame.size.height
       return navBarHeight
     }

}
