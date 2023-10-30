//
//  SplashScreenViewPresenter.swift
//  WireguardApp
//
//  Created by Сергей on 22.05.2023.
//

import Foundation

protocol SplashScreenViewProtocol {

}

class SplashScreenViewPresenter {

    var view: SplashScreenViewProtocol?

    func setViewProtocol(_ view: SplashScreenViewProtocol) {
        self.view = view
    }

    init() {

    }
}

struct SplashScreenModel {

}

