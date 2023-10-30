//
//  PayViewController.swift
//  VPN
//
//  Created by Сергей on 29.04.2023.
//

import UIKit

class PayViewController: UIViewController {

    let presenter: PayViewPresenter!
    let mainView = PayView()
    var payment = [PaymentAttempt]()
    var data = [Pay]()
    var selected: IndexPath? = [0, 0]
    var recurrent: Bool? = false

    override func loadView() {
        super.viewDidLoad()
        self.view = mainView
    }

    init(with presenter: PayViewPresenter) {
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
        if Storage.getKeyStorage(name: "payment") != nil {
            let jsonString = Storage.getKeyStorage(name: "payment", type: String.self)
            if let dataFromJsonString = jsonString!.data(using: .utf8) {
                do {
                    payment = try JSONDecoder().decode([PaymentAttempt].self, from: dataFromJsonString)
                    generatePayment(data: payment)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        presenter.setViewProtocol(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.navigationBar.isHidden = false
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
        let doneItem = UIBarButtonItem(title: NSLocalizedString("PAY", comment: ""), style: .done, target: self, action: #selector(payAction))
        navigationItem.hidesBackButton = false
        navigationItem.rightBarButtonItem = doneItem
        navigationItem.title = NSLocalizedString("PAYMENT", comment: "")
    }

    private func load() {
        if Reachability.isConnectedToNetwork() == true {
            mainView.activityIndicatorView.startAnimating()
            mainView.activityIndicatorView.isHidden = false
            let parameters = ["token": UniqueUUID.getUUID()!, "lang": Locale.current.languageCode!] as [String: Any]
            presenter.payment(parameters: parameters)
        } else {
            self.presentAlert(title: NSLocalizedString("ERROR", comment: ""),  message: NSLocalizedString("NO_INTERNET", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        }
    }

    func generatePayment(data: [PaymentAttempt]) {
        var name = [String]()
        var price = [String]()
        for offers in data[0].offers! {
            name.append(offers.name!)
            price.append(offers.price!)
        }
        let rates = Pay.init(header: NSLocalizedString("RATES", comment: ""), name: name, value: price)
        var title = [String]()
        var value = [String]()
        for buttons in data[0].buttons! {
            title.append(buttons.title!)
            value.append(buttons.url!)
        }
        /*title.append(NSLocalizedString("BANK_CARD", comment: ""))
        value.append("")*/
        title.append(NSLocalizedString("LINK_CARD", comment: ""))
        value.append("switch")
        recurrent = data[0].recurrent!
        let payment_method = Pay.init(header: NSLocalizedString("PAYMENT_METHOD", comment: ""), name: title, value: value)
        self.data = [rates, payment_method]
    }

    @objc func payAction() {
        let parameters = ["token": UniqueUUID.getUUID()!, "offer_id": payment[0].offers![selected!.row].offer_id!, "recurrent": recurrent! ? 1 : 0] as [String: Any]
        let webViewController = WebViewController(with: WebViewPresenter())
        webViewController.url = payment[0].payment_link!
        webViewController.name = NSLocalizedString("PAYMENT", comment: "")
        webViewController.parameters = parameters
        navigationController?.pushViewController(webViewController, animated: true)
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func switchChanged(_ sender : UISwitch!){
        recurrent = sender.isOn
    }

    @objc func refresh(_ sender: AnyObject) {
        load()
    }

    @IBAction func tapInfo(gesture: UITapGestureRecognizer) {
        let label: UILabel = (gesture.view as! UILabel)
        let text = (label.text)!
        let range = (text as NSString).range(of: NSLocalizedString("AUTOMATIC_CANCELLATION", comment: ""))
        if gesture.didTapAttributedTextInLabel(label: label, inRange: range) {
            let webViewController = WebViewController(with: WebViewPresenter())
            webViewController.url = payment[0].recurrent_offer!
            navigationController?.pushViewController(webViewController, animated: true)
        }
        let range1 = (text as NSString).range(of: NSLocalizedString("PERSONAL_DATA", comment: ""))
        if gesture.didTapAttributedTextInLabel(label: label, inRange: range1) {
            let webViewController = WebViewController(with: WebViewPresenter())
            webViewController.url = payment[0].policy!
            navigationController?.pushViewController(webViewController, animated: true)
        }
        let range2 = (text as NSString).range(of: NSLocalizedString("PUBLIC_OFFER", comment: ""))
        if gesture.didTapAttributedTextInLabel(label: label, inRange: range2) {
            let webViewController = WebViewController(with: WebViewPresenter())
            webViewController.url = payment[0].offer!
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}

extension PayViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 55
    }

}

extension PayViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PayTableHeader.identifier) as! PayTableHeader
        view.title.text = data[section].header
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PayTableFooter.identifier) as! PayTableFooter
        if section == 1 {
            view.title.text = NSLocalizedString("INFO_CARD", comment: "")
            let text = (view.title.text)!
            let underlineAttriString = NSMutableAttributedString(string: text)
            let range1 = (text as NSString).range(of: NSLocalizedString("INFO_CARD", comment: ""))
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Constants.COLORS.COLOR_GRAY3_LIGHT, range: range1)
            let range2 = (text as NSString).range(of: NSLocalizedString("AUTOMATIC_CANCELLATION", comment: ""))
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.currentTheme.textTableCellColor, range: range2)
            view.title.attributedText = underlineAttriString
        } else {
            view.title.text = NSLocalizedString("INFO_PAY", comment: "")
            let text = (view.title.text)!
            let underlineAttriString = NSMutableAttributedString(string: text)
            let range1 = (text as NSString).range(of: NSLocalizedString("INFO_PAY", comment: ""))
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Constants.COLORS.COLOR_GRAY3_LIGHT, range: range1)
            let range2 = (text as NSString).range(of: NSLocalizedString("PERSONAL_DATA", comment: ""))
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.currentTheme.textTableCellColor, range: range2)
            let range3 = (text as NSString).range(of: NSLocalizedString("PUBLIC_OFFER", comment: ""))
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.currentTheme.textTableCellColor, range: range3)
            view.title.attributedText = underlineAttriString
        }
        view.title.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapInfo(gesture:))))
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PayTableCell.identifier) as! PayTableCell
            cell.name.textColor = Theme.currentTheme.textTableCellColor
            cell.name.text = data[indexPath.section].name![indexPath.row]
            cell.value.text = data[indexPath.section].value![indexPath.row]
            if selected == indexPath {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.backgroundColor = Theme.currentTheme.backgroundTableCellColor
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PayTableCell2.identifier) as! PayTableCell2
            cell.selectionStyle = .none
            cell.name.textColor = Theme.currentTheme.textTableCellColor
            cell.name.text = data[indexPath.section].name![indexPath.row]
            if (data[indexPath.section].value![indexPath.row] == "switch") {
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(recurrent!, animated: true)
                switchView.tag = indexPath.row
                switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
            } else {
                cell.accessoryView = nil
            }
            cell.backgroundColor = Theme.currentTheme.backgroundTableCellColor
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].name!.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if indexPath.section == 0 {
            selected = indexPath
            tableView.reloadData()
        } else {
            if (data[indexPath.section].value![indexPath.row] != "switch") {
                guard URL(string: data[indexPath.section].value![indexPath.row]) != nil else {
                    return
                }
                let webViewController = WebViewController(with: WebViewPresenter())
                webViewController.url = data[indexPath.section].value![indexPath.row]
                webViewController.name = data[indexPath.section].name![indexPath.row]
                navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        }
    }

}

extension PayViewController: PayViewProtocol {

    func pay(data: [PaymentAttempt]) {
        mainView.refreshControl.endRefreshing()
        mainView.activityIndicatorView.stopAnimating()
        mainView.activityIndicatorView.isHidden = true
        do {
            let encodedData = try JSONEncoder().encode(data)
            let json = String(data: encodedData, encoding: .utf8)
            Storage.setKeyStorage(value: json!, name: "payment")
        } catch let error {
            print(error.localizedDescription)
        }
        self.payment = data
        generatePayment(data: data)
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

