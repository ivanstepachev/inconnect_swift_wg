//
//  SettingsViewController.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import UIKit
import Toast_Swift

class SettingsViewController: UIViewController {

    let presenter: SettingsViewPresenter!
    let mainView = SettingsView()
    var settings = [SettingsAttempt]()
    var data = [Settings]()

    override func loadView() {
        super.viewDidLoad()
        self.view = mainView
    }

    init(with presenter: SettingsViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        if Storage.getKeyStorage(name: "settings") != nil {
            let jsonString = Storage.getKeyStorage(name: "settings", type: String.self)
            if let dataFromJsonString = jsonString!.data(using: .utf8) {
                do {
                    settings = try JSONDecoder().decode([SettingsAttempt].self, from: dataFromJsonString)
                    generateMenu(data: settings)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        presenter.setViewProtocol(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        load()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController!.navigationBar.isHidden = true
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
        mainView.tableView.backgroundColor = Theme.currentTheme.backgroundTableColor
        mainView.refreshControl.tintColor = Theme.currentTheme.textTableCellColor
        mainView.activityIndicatorView.color = Theme.currentTheme.textTableCellColor
        mainView.tableView.reloadData()
    }

    func setupNavigationBar() {
        let doneItem = UIBarButtonItem(title: NSLocalizedString("DONE", comment: ""), style: .done, target: self, action: #selector(doneAction))
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = doneItem
        navigationItem.title = NSLocalizedString("SETTINGS", comment: "")
    }

    private func load() {
        if Reachability.isConnectedToNetwork() == true {
            mainView.activityIndicatorView.startAnimating()
            mainView.activityIndicatorView.isHidden = false
            let parameters = ["token": UniqueUUID.getUUID()!, "lang": Locale.current.languageCode!] as [String: Any]
            presenter.menu(parameters: parameters)
        } else {
            self.presentAlert(title: NSLocalizedString("ERROR", comment: ""),  message: NSLocalizedString("NO_INTERNET", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        }
    }

    func generateMenu(data: [SettingsAttempt]) {
        self.data = []
        let isVisible = data[0].button!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        for (index, data) in data[0].menu!.enumerated() {
            var title = [String]()
            var value = [String]()
            var url = [String]()
            var copy = [Bool]()
            for button in data.buttons! {
                title.append(button.title!)
                value.append(button.value!)
                url.append(button.url!)
                copy.append(button.copy_value!)
            }
            if (index == 0) {
                title.append(NSLocalizedString("TO_PAY_SUBSCRIPTION", comment: ""))
                value.append("")
                url.append("")
                copy.append(false)
            } else if (index == 1) {
                title.append(NSLocalizedString("VERSION_APP", comment: ""))
                value.append("\(version!).\(build!)")
                url.append("")
                copy.append(false)
            }
            if (index == 0) {
                if isVisible {
                    self.data.append(Settings.init(header: data.name, name: title, value: value, url: url, copy: copy))
                }
            } else {
                self.data.append(Settings.init(header: data.name, name: title, value: value, url: url, copy: copy))
            }
        }
    }

    @objc func doneAction() {
        navigationController!.popViewController(animated: true)
    }

    @objc func refresh(_ sender: AnyObject) {
        load()
    }

}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }

}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingsTableHeader.identifier) as! SettingsTableHeader
        view.title.text = data[section].header
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.identifier) as! SettingsTableCell
        cell.name.textColor = Theme.currentTheme.textTableCellColor
        cell.value.textColor = Constants.COLORS.COLOR_GRAY3_LIGHT
        cell.name.text = data[indexPath.section].name![indexPath.row]
        cell.value.text = data[indexPath.section].value![indexPath.row].trunc(length: 16).lowercased()
        if (data[indexPath.section].header == NSLocalizedString("SUBSCRIPTION", comment: "") ) {
            if (indexPath.row == 0) {
                cell.value.textColor = Constants.COLORS.COLOR_RED
                let day: Int = Int(data[indexPath.section].value![indexPath.row])!
                cell.value.text = day.days()
            } else if (indexPath.row == 1) {
                cell.name.textColor = Constants.COLORS.COLOR_BLUE
            } else {
                cell.value.textColor = Constants.COLORS.COLOR_GRAY3_LIGHT
            }
        }
        cell.backgroundColor = Theme.currentTheme.backgroundTableCellColor
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].name!.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if (data[indexPath.section].name![indexPath.row] == NSLocalizedString("TO_PAY_SUBSCRIPTION", comment: "")) {
            let payViewController = PayViewController(with: PayViewPresenter())
            navigationController?.pushViewController(payViewController, animated: true)
        } else {
            if (data[indexPath.section].copy![indexPath.row]) {
                UIPasteboard.general.string = data[indexPath.section].value![indexPath.row].lowercased()
                var style = ToastStyle()
                style.messageColor = Theme.currentTheme.textTableCellColor
                style.backgroundColor = Theme.currentTheme.timeLightColor
                self.view.makeToast(NSLocalizedString("COPY_CLIPBOARD", comment: ""), duration: 3.0, position: .top, style: style)
            } else {
                if let url = URL(string: data[indexPath.section].url![indexPath.row]), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                /*guard URL(string: data[indexPath.section].url![indexPath.row]) != nil else {
                  return
                }
                let webViewController = WebViewController(with: WebViewPresenter())
                webViewController.url = data[indexPath.section].url![indexPath.row]
                webViewController.name = data[indexPath.section].name![indexPath.row]
                navigationController?.pushViewController(webViewController, animated: true)*/
            }
        }
    }

}

extension SettingsViewController: SettingsViewProtocol {

    func menu(data: [SettingsAttempt]) {
        mainView.refreshControl.endRefreshing()
        mainView.activityIndicatorView.stopAnimating()
        mainView.activityIndicatorView.isHidden = true
        do {
            let encodedData = try JSONEncoder().encode(data)
            let json = String(data: encodedData, encoding: .utf8)
            Storage.setKeyStorage(value: json!, name: "settings")
        } catch let error {
            print(error.localizedDescription)
        }
        generateMenu(data: data)
        mainView.tableView.reloadData()
    }

    func failure() {
        mainView.refreshControl.endRefreshing()
        mainView.activityIndicatorView.stopAnimating()
        mainView.activityIndicatorView.isHidden = true
        self.presentAlert(title: NSLocalizedString("MESSAGE", comment: ""),  message: NSLocalizedString("NO_RESPONSE_REMOTE_SERVICE", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
            {_ in
                self.dismiss(animated: true, completion: nil)
            }
        ])
    }

}
