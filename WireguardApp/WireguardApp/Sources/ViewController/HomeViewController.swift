//
//  ViewController.swift
//  VPN
//
//  Created by Сергей on 28.04.2023.
//

import UIKit
import Network
import NetworkExtension

class HomeViewController: UIViewController {

    let presenter: HomeViewPresenter!
    let mainView = HomeView()
    var config = [ConnectAttempt]()
    var push_token: String = ""
    var isConnect: Bool = false
    var timer: Timer?
    var days: Int? = 0
    var tunnel: TunnelContainer?
    var tunnelsManager: TunnelsManager?
    var tunnelViewModel: TunnelViewModel?
    var onTunnelsManagerReady: ((TunnelsManager) -> Void)?

    fileprivate func setupWireguardProtocol(isProfileInstalled: Bool) {
        TunnelsManager.create { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tunnelsManager):
                var containers = [TunnelContainer]()
                for i in 0..<tunnelsManager.numberOfTunnels() {
                    containers.append(tunnelsManager.tunnel(at: i))
                }
                self.tunnelsManager?.closureDidGetStatus = nil
                self.tunnelsManager = nil
                self.tunnelsManager = tunnelsManager
                tunnelsManager.activationDelegate = self
                tunnelsManager.tunnelsListDelegate = self
                self.onTunnelsManagerReady?(tunnelsManager)
                self.onTunnelsManagerReady = nil
                self.tunnelViewModel = TunnelViewModel(tunnelConfiguration: nil)
                if !isProfileInstalled {
                    tunnelsManager.addConfiguration(tunnelsManager: self.tunnelsManager!, fileName: Constants.APP.NAME, privateKey: config[0].privatekey!, address: config[0].address!, dns: config[0].dns!, publicKey: config[0].publickey!, endpoint: config[0].endpoint!, allowedIPs: config[0].allowed_ips!, persistentKeepAlive: String(config[0].pers_keep_alive!))
                }
            }
        }
    }

    fileprivate func getTunnelIfAlreadyConnected() {
        TunnelsManager.shared.loadPreferencesIfAlreadyConnected { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let tunnelsManager):
                var containers = [TunnelContainer]()
                for i in 0..<tunnelsManager.numberOfTunnels() {
                    containers.append(tunnelsManager.tunnel(at: i))
                }
                self.tunnel = tunnelsManager.tunnel(at: 0)
                self.tunnelsManager?.closureDidGetStatus = nil
                self.tunnelsManager = nil
                self.tunnelsManager = tunnelsManager
                tunnelsManager.activationDelegate = self
                tunnelsManager.tunnelsListDelegate = self
                self.onTunnelsManagerReady?(tunnelsManager)
                self.onTunnelsManagerReady = nil
                self.tunnelViewModel = TunnelViewModel(tunnelConfiguration: nil)
            }
        }
    }

    fileprivate func startWireguardVPN() {
        if let tunnell = tunnelsManager?.tunnel(named: Constants.APP.NAME) {
            self.tunnel = tunnell
            tunnel?.isAttemptingActivation = false
            self.tunnelsManager?.startActivation(of: self.tunnel!)
        }
    }

    fileprivate func stopWireguardVPN() {
        self.tunnel?.tunnelProvider.connection.stopVPNTunnel()
    }

    override func loadView() {
        super.viewDidLoad()
        self.view = mainView
    }

    init(with presenter: HomeViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let uuid = UniqueUUID.getUUID()
        print("UUID: \(uuid)")

        initTunnel()
        mainView.menuAction = { [weak self] in self?.menuAction() }
        mainView.payAction = { [weak self] in self?.payAction() }
        mainView.pay_button.isHidden = true
        mainView.subscription_days.isHidden = true
        mainView.my_switch.isEnabled = false
        mainView.my_switch.isOn { (value) in
            TunnelsManager.checkVPNStatus { (status) in
                if (value) {
                    if status != .connected {
                        self.connect()
                    }
                } else {
                    if status == .connected {
                        self.isConnect = false
                        self.stopWireguardVPN()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.disconnect()
                        }
                    }
                }
            }
        }
        if Storage.getKeyStorage(name: "load") != nil {
            let jsonString = Storage.getKeyStorage(name: "load", type: String.self)
            if let dataFromJsonString = jsonString!.data(using: .utf8) {
                do {
                    let load = try JSONDecoder().decode([LoadAttempt].self, from: dataFromJsonString)
                    self.days = load[0].days!
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        presenter.setViewProtocol(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.indicator.startAnimation(delay: 0.04, replicates: 16)
        mainView.indicator.stopAnimation()
        load()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Theme.currentTheme = UITraitCollection.current.userInterfaceStyle == .dark ? DarkTheme() : LightTheme()
        updateColor(theme: Theme.currentTheme)
    }

    func updateColor(theme: ThemeProtocol) {
        mainView.backgroundColor = Theme.currentTheme.backgroundColor
        mainView.menu_button.setImage(Theme.currentTheme.menuImage.withRenderingMode(.alwaysOriginal), for: .normal)
        if (tunnel?.tunnelProvider.connection.status == .connected || tunnel?.tunnelProvider.connection.status == .connecting) {
            mainView.status.textColor = Theme.currentTheme.statusDarkColor
            mainView.time.textColor = Theme.currentTheme.timeDarkColor
        } else {
            mainView.status.textColor = Theme.currentTheme.statusLightColor
            mainView.time.textColor = Theme.currentTheme.timeLightColor
        }
        mainView.my_switch.onTintColor = Theme.currentTheme.switchOnTintColor
        mainView.my_switch.offTintColor = Theme.currentTheme.switchOffTintColor
        mainView.my_switch.thumbTintColor = Theme.currentTheme.switchThumbTintColor
        mainView.activityIndicatorView.color = Theme.currentTheme.subscriptionColor
        mainView.pay_button.backgroundColor = Theme.currentTheme.buttonBackgroundColor
        mainView.pay_button.setImage(Theme.currentTheme.cardImage.withRenderingMode(.alwaysOriginal), for: .normal)
        mainView.pay_button.setAttributedTitle(NSAttributedString(string: NSLocalizedString("TO_PAY_SUBSCRIPTION", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : Theme.currentTheme.buttonTextColor, NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 17)!]), for: .normal)
        if (self.days! < 5 && self.days! > 0) { mainView.subscription_days.textColor = Constants.COLORS.COLOR_RED } else { mainView.subscription_days.textColor = Theme.currentTheme.subscriptionColor }
    }

    private func initTunnel() {
        TunnelsManager.checkVPNConfigurationInstalled { (isProfileInstalled, status) in
            if isProfileInstalled {
                if status == .connected {
                    self.getTunnelIfAlreadyConnected()
                } else {
                    self.setupWireguardProtocol(isProfileInstalled: true)
                    self.startWireguardVPN()
                }
                self.tunnelStatusDidChange(status: status)
            } else {
                if self.config.count != 0 {
                    self.setupWireguardProtocol(isProfileInstalled: false)
                }
            }
        }
    }

    private func load() {
        if Reachability.isConnectedToNetwork() == true {
            self.view.isUserInteractionEnabled = false
            mainView.activityIndicatorView.startAnimating()
            mainView.activityIndicatorView.isHidden = false
            if (Storage.getKeyStorage(name: "fcmToken") != nil) {
                push_token = Storage.getKeyStorage(name: "fcmToken") as! String
            }
            let parameters = ["token": UniqueUUID.getUUID()!, "os": "ios", "push_token": push_token] as [String: Any]
            presenter.load(parameters: parameters)
        } else {
            self.presentAlert(title: NSLocalizedString("ERROR", comment: ""),  message: NSLocalizedString("NO_INTERNET", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        }
    }

    private func connect() {
        if Reachability.isConnectedToNetwork() == true {
            self.view.isUserInteractionEnabled = false
            let parameters = ["token": UniqueUUID.getUUID()!] as [String: Any]
            self.presenter.connect(parameters: parameters)
        } else {
            self.presentAlert(title: NSLocalizedString("ERROR", comment: ""),  message: NSLocalizedString("NO_INTERNET", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        }
    }

    private func disconnect() {
        if Reachability.isConnectedToNetwork() == true {
            //self.view.isUserInteractionEnabled = false
            let parameters = ["token": UniqueUUID.getUUID()!] as [String: Any]
            self.presenter.disconnect(parameters: parameters)
        } else {
            self.presentAlert(title: NSLocalizedString("ERROR", comment: ""),  message: NSLocalizedString("NO_INTERNET", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        }
    }

    private func reconnect() {
        if Reachability.isConnectedToNetwork() == true {
            self.view.isUserInteractionEnabled = false
            let parameters = ["token": UniqueUUID.getUUID()!] as [String: Any]
            self.presenter.reconnect(parameters: parameters)
        } else {
            self.presentAlert(title: NSLocalizedString("ERROR", comment: ""),  message: NSLocalizedString("NO_INTERNET", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        }
    }

    private func menuAction() {
        let settingsViewController = SettingsViewController(with: SettingsViewPresenter())
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }

    private func payAction() {
        let payViewController = PayViewController(with: PayViewPresenter())
        self.navigationController?.pushViewController(payViewController, animated: true)
    }

    @objc func updateTimer() {
        mainView.time.text = Date().offsetFrom(date: (tunnel?.tunnelProvider.connection.connectedDate)!)
    }

}

extension HomeViewController: HomeViewProtocol {

    func load(data: [LoadAttempt]) {
        self.view.isUserInteractionEnabled = true
        mainView.activityIndicatorView.stopAnimating()
        mainView.activityIndicatorView.isHidden = true
        do {
            let encodedData = try JSONEncoder().encode(data)
            let json = String(data: encodedData, encoding: .utf8)
            Storage.setKeyStorage(value: json!, name: "load")
        } catch let error {
            print(error.localizedDescription)
        }
        self.days = data[0].days!
        if (data[0].status == "user") {
            mainView.my_switch.isEnabled = true
            mainView.subscription_days.text = "\(self.days!.days()) \(NSLocalizedString("SUBSCRIPTION_DAYS", comment: ""))"
            if (data[0].days! < 5 && data[0].days! > 0) { mainView.subscription_days.textColor = Constants.COLORS.COLOR_RED } else { mainView.subscription_days.textColor = Theme.currentTheme.subscriptionColor }
            if (data[0].days == 0) {
                mainView.status.text = "\(NSLocalizedString("SUBSCRIPTION_EMDED", comment: ""))"
                mainView.subscription_days.text = "\(NSLocalizedString("ACTIVATE_SUBSCRIPTION", comment: ""))"
                mainView.my_switch.isEnabled = false
                TunnelsManager.checkVPNStatus { (status) in
                    if status == .connected {
                        self.stopWireguardVPN()
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.disconnect()
                        }
                    }
                }
            }
        } else if (data[0].status == "new") {
            mainView.subscription_days.text = "\(NSLocalizedString("ACTIVATE_SUBSCRIPTION", comment: ""))"
            mainView.my_switch.isEnabled = false
        } else if (data[0].status == "error") {
            mainView.status.text = "\(NSLocalizedString("COME_PROBLEM", comment: ""))"
            mainView.status.textColor = Constants.COLORS.COLOR_RED
            mainView.my_switch.isEnabled = false
        }
        if (data[0].button!) {
            mainView.pay_button.isHidden = false
            mainView.subscription_days.isHidden = false
        } else {
            mainView.pay_button.isHidden = true
            mainView.subscription_days.isHidden = true
        }
    }

    func connect(data: [ConnectAttempt]) {
        self.view.isUserInteractionEnabled = true
        if (data[0].status == "ok") {
            self.isConnect = true
            config = data
            TunnelsManager.checkVPNConfigurationInstalled { (isProfileInstalled, status) in
                if isProfileInstalled {
                    let confString = "[Interface]\nPrivateKey = \(data[0].privatekey!)\nAddress = \(data[0].address!)\nDNS = \(data[0].dns!)\n\n[Peer]\nPublicKey = \(data[0].publickey!)\nEndpoint = \(data[0].endpoint!)\nAllowedIPs = \(data[0].allowed_ips!)\nPersistentKeepalive = \(data[0].pers_keep_alive!)\n"
                    do {
                        let tunnelConfig = try TunnelConfiguration(fromWgQuickConfig: confString, called: Constants.APP.NAME)
                        self.tunnelsManager?.modify(tunnel: self.tunnelsManager!.tunnel(at: 0), tunnelConfiguration: tunnelConfig, onDemandOption: .off, completionHandler: {_ in })
                    } catch {
                        print(error)
                    }
                } else {
                    self.initTunnel()
                }
            }
        } else if (data[0].status == "error") {
            mainView.status.text = "\(NSLocalizedString("COME_PROBLEM", comment: ""))"
            mainView.status.textColor = Constants.COLORS.COLOR_RED
            mainView.my_switch.setOn(on: false, animated: true)
        }
    }

    func reconnect(data: [ConnectAttempt]) {
        self.view.isUserInteractionEnabled = true
        if (data[0].status == "ok") {

        } else if (data[0].status == "error") {
            mainView.status.text = "\(NSLocalizedString("COME_PROBLEM", comment: ""))"
            mainView.status.textColor = Constants.COLORS.COLOR_RED
        }
    }

    func disconnect(data: [DisconnectAttempt]) {
        self.view.isUserInteractionEnabled = true
        if (data[0].status == "ok") {
            //self.stopWireguardVPN()
        } else if (data[0].status == "error") {
            mainView.status.text = "\(NSLocalizedString("COME_PROBLEM", comment: ""))"
            mainView.status.textColor = Constants.COLORS.COLOR_RED
        }
    }

    func failure(data: String) {
        self.view.isUserInteractionEnabled = true
        mainView.activityIndicatorView.stopAnimating()
        mainView.activityIndicatorView.isHidden = true
        switch data {
        case "load":
            print("error load")
            TunnelsManager.checkVPNStatus { (status) in
                if status == .connected {
                    self.stopWireguardVPN()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.load()
                }
            }
        case "connect":
            print("error connect")
            self.presentAlert(title: NSLocalizedString("MESSAGE", comment: ""),  message: NSLocalizedString("NO_RESPONSE_REMOTE_SERVICE", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        case "reconnect":
            print("error reconnect")
            self.presentAlert(title: NSLocalizedString("MESSAGE", comment: ""),  message: NSLocalizedString("NO_RESPONSE_REMOTE_SERVICE", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        case "disconnect":
            print("error disconnect")
        default:
            print("error default")
            self.presentAlert(title: NSLocalizedString("MESSAGE", comment: ""),  message: NSLocalizedString("NO_RESPONSE_REMOTE_SERVICE", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        }
    }

}

extension HomeViewController: TunnelsManagerActivationDelegate, TunnelsManagerListDelegate {

    func tunnelConfigurationError(error: String) {
        print("tunnelConfigurationError : \(error)")
        if error == "Unable to create tunnel" {
            mainView.my_switch.setOn(on: false, animated: true)
        }
    }

    func tunnelActivationAttemptFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationAttemptError) {
        print("tunnelActivationAttemptFailed : \(error)")
    }

    func tunnelActivationAttemptSucceeded(tunnel: TunnelContainer) {
        print("tunnelActivationAttemptSucceeded")
    }

    func tunnelActivationFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationError) {
        print("tunnelActivationFailed : \(error)")
    }

    func tunnelActivationSucceeded(tunnel: TunnelContainer) {
        print("tunnelActivationSucceeded")
    }

    func tunnelAdded(at index: Int) {
        print("Tunnel Added")
        self.startWireguardVPN()
    }

    func tunnelModified(at index: Int) {
        print("Tunnel Modified")
        initTunnel()
    }

    func tunnelMoved(from oldIndex: Int, to newIndex: Int) {
        print("Tunnel Moved")
    }

    func tunnelRemoved(at index: Int, tunnel: TunnelContainer) {
        print("Tunnel Removed")
    }

    func tunnelStatusDidChange(status: NEVPNStatus) {
        print("Tunnel Status: \(status)")
        switch status {
        case .connected:
            mainView.status.text = "\(NSLocalizedString("CONNECTED", comment: ""))"
            mainView.status.textColor = Theme.currentTheme.statusDarkColor
            mainView.time.textColor = Theme.currentTheme.timeDarkColor
            mainView.time.isHidden = false
            mainView.my_switch.isEnabled = true
            self.mainView.indicator.stopAnimation()
            mainView.my_switch.setOn(on: true, animated: true)
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        case .connecting:
            mainView.status.text = "\(NSLocalizedString("CONNECTION", comment: ""))"
            mainView.status.textColor = Theme.currentTheme.statusDarkColor
            mainView.time.textColor = Theme.currentTheme.timeDarkColor
            mainView.time.isHidden = true
            mainView.my_switch.isEnabled = false
            self.mainView.indicator.startAnimation(delay: 0.04, replicates: 16)
            //mainView.my_switch.setOn(on: true, animated: true)
        case .disconnected:
            mainView.status.text = "\(NSLocalizedString("DISABLED", comment: ""))"
            mainView.status.textColor = Theme.currentTheme.statusLightColor
            mainView.time.textColor = Theme.currentTheme.timeLightColor
            if !isConnect {
                mainView.time.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if (self.days == 0) { self.mainView.my_switch.isEnabled = false } else { self.mainView.my_switch.isEnabled = true }
                    self.mainView.my_switch.setOn(on: false, animated: true)
                }
                self.mainView.indicator.stopAnimation()
                mainView.time.text = "00:00:00"
                timer?.invalidate()
                timer = nil
            }
        case .disconnecting:
            mainView.status.text = "\(NSLocalizedString("DISABLING", comment: ""))"
            mainView.status.textColor = Theme.currentTheme.statusLightColor
            mainView.time.textColor = Theme.currentTheme.timeLightColor
            mainView.time.isHidden = true
            mainView.my_switch.isEnabled = false
            self.mainView.indicator.startAnimation(delay: 0.04, replicates: 16)
            //mainView.my_switch.setOn(on: false, animated: true)
        default:
            mainView.status.text = "\(NSLocalizedString("DISABLED", comment: ""))"
            mainView.status.textColor = Theme.currentTheme.statusLightColor
            mainView.time.textColor = Theme.currentTheme.timeLightColor
            mainView.time.isHidden = false
            mainView.my_switch.isEnabled = true
            self.mainView.indicator.stopAnimation()
            mainView.my_switch.setOn(on: false, animated: true)
        }
    }
}
