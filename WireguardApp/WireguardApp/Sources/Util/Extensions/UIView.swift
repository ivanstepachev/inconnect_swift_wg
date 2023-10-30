//
//  UIView.swift
//  VPN
//
//  Created by Сергей on 28.04.2023.
//

import UIKit

extension UIView {

    var safeAreaTop: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            return window.safeAreaInsets.top
        }
        return bounds.height
    }

    var safeAreaBottom: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            return window.safeAreaInsets.bottom
        }
        return bounds.height
    }

    public var viewWidth: CGFloat {
        return self.frame.size.width
    }

    public var viewHeight: CGFloat {
        return self.frame.size.height
    }


}
