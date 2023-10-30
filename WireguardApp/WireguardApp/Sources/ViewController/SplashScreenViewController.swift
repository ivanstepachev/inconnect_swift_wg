//
//  SplashScreenViewController.swift
//  WireguardApp
//
//  Created by Сергей on 22.05.2023.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let presenter: SplashScreenViewPresenter!
    let mainView = SplashScreenView()
    var timer: Timer?
    var delay = Constants.APP.SPLASH_SCREEN_DELAY

    override func loadView() {
        super.viewDidLoad()
        self.view = mainView
    }

    init(with presenter: SplashScreenViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewProtocol(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
    }

    @objc func updateTimer() {
        timer?.invalidate()
        timer = nil
        //let mainViewController = PayViewController(with: PayViewPresenter())
        //let mainViewController = SettingsViewController(with: SettingsViewPresenter())
        let mainViewController = HomeViewController(with: HomeViewPresenter())
        mainViewController.view.layer.bottomAnimation(duration: 0.25)
        self.navigationController?.setViewControllers([mainViewController], animated: false)
    }

}

extension SplashScreenViewController: SplashScreenViewProtocol {

}
