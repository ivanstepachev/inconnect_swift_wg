//
//  UITableViewCell.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import UIKit

extension UITableViewCell {
    var selectionColor: UIColor {
        set {
            let view = UIView()
            view.backgroundColor = newValue
            self.selectedBackgroundView = view
        }
        get {
            return self.selectedBackgroundView?.backgroundColor ?? UIColor.clear
        }
    }
}
