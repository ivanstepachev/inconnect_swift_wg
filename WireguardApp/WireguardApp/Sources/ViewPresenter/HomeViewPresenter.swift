//
//  HomeViewPresenter.swift
//  VPN
//
//  Created by Сергей on 28.04.2023.
//

import Foundation

protocol HomeViewProtocol {
    func load(data: [LoadAttempt])
    func connect(data: [ConnectAttempt])
    func reconnect(data: [ConnectAttempt])
    func disconnect(data: [DisconnectAttempt])
    func failure(data: String)
}

class HomeViewPresenter {

    var view: HomeViewProtocol?

    func setViewProtocol(_ view: HomeViewProtocol) {
        self.view = view
    }

    func load(parameters: [String: Any]) {
        API.load(parameters: parameters) { (status: Bool, items: [LoadAttempt]?) in
            DispatchQueue.main.async { [self] in
                if status {
                    view?.load(data: items!)
                } else {
                    view?.failure(data: "load")
                }
            }
        }
    }

    func connect(parameters: [String: Any]) {
        API.connect(parameters: parameters) { (status: Bool, items: [ConnectAttempt]?) in
            DispatchQueue.main.async { [self] in
                if status {
                    view?.connect(data: items!)
                } else {
                    view?.failure(data: "connect")
                }
            }
        }
    }

    func reconnect(parameters: [String: Any]) {
        API.connect(parameters: parameters) { (status: Bool, items: [ConnectAttempt]?) in
            DispatchQueue.main.async { [self] in
                if status {
                    view?.reconnect(data: items!)
                } else {
                    view?.failure(data: "reconnect")
                }
            }
        }
    }

    func disconnect(parameters: [String: Any]) {
        API.disconnect(parameters: parameters) { (status: Bool, items: [DisconnectAttempt]?) in
            DispatchQueue.main.async { [self] in
                if status {
                    view?.disconnect(data: items!)
                } else {
                    view?.failure(data: "disconnect")
                }
            }
        }
    }

    init() {

    }
}

struct HomeModel {

}

