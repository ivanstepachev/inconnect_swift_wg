//
//  SettingsViewPresenter.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import Foundation

protocol SettingsViewProtocol {
    func menu(data: [SettingsAttempt])
    func failure()
}

class SettingsViewPresenter {

    var view: SettingsViewProtocol?

    func setViewProtocol(_ view: SettingsViewProtocol) {
        self.view = view
    }

    func menu(parameters: [String: Any]) {
        API.menu(parameters: parameters) { (status: Bool, items: [SettingsAttempt]?) in
            DispatchQueue.main.async { [self] in
                if status {
                    view?.menu(data: items!)
                } else {
                    view?.failure()
                }
            }
        }
    }

    init() {

    }
}

struct SettingsModel {

}
