//
//  UIViewController.swift
//  VPN
//
//  Created by Сергей on 02.05.2023.
//

import UIKit

extension UIViewController {

    func openWebView(url: String, name: String = "", parameters: [String: Any] = [:]) {
        let webViewController = WebViewController(with: WebViewPresenter())
        webViewController.url = url
        webViewController.name = name
        webViewController.parameters = parameters
        self.present(webViewController, animated: true, completion: nil)
    }

    func presentDetail(_ viewControllerToPresent: UIViewController, type: CATransitionType, subtype:  CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        transition.subtype = subtype
        self.view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail(type: CATransitionType, subtype:  CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = type
        transition.subtype = subtype
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }

    func presentAlert(title: String, message: String, alertStyle: UIAlertController.Style, actionTitles: [String], actionStyles: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)]) {
        let alertController = UIAlertController(title: title.isEmpty ? nil : title, message: message.isEmpty ? nil : message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated() {
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.view.tintColor = Constants.COLORS.COLOR_BLUE
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }

}
