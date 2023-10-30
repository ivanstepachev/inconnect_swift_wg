//
//  CALayer.swift
//  WireguardApp
//
//  Created by Сергей on 22.05.2023.
//

import UIKit

extension CALayer {

    func bottomAnimation(duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = duration
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }

    func topAnimation(duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = duration
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }

    func rightAnimation(duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = duration
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromLeft
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }

    func leftAnimation(duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = duration
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromRight
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
