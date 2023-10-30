//
//  PayViewPresenter.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import Foundation

protocol PayViewProtocol {
    func pay(data: [PaymentAttempt])
    func failure()
}

class PayViewPresenter {

    var view: PayViewProtocol?

    func setViewProtocol(_ view: PayViewProtocol) {
        self.view = view
    }

    func payment(parameters: [String: Any]) {
        API.payment(parameters: parameters) { (status: Bool, items: [PaymentAttempt]?) in
            DispatchQueue.main.async { [self] in
                if status {
                    view?.pay(data: items!)
                } else {
                    view?.failure()
                }
            }
        }
    }

    init() {

    }
}

struct PayModel {

}
