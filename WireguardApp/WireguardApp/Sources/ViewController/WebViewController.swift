//
//  WebViewController.swift
//  VPN
//
//  Created by Сергей on 06.05.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    let presenter: WebViewPresenter!
    let mainView = WebView()
    private var webView: WKWebView!
    public var url: String!
    public var name: String! = ""
    public var parameters: [String: Any]! = [:]

    override func loadView() {
        super.viewDidLoad()
        self.view = mainView
    }

    init(with presenter: WebViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        webView = mainView.webView
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
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
        mainView.backgroundColor = Theme.currentTheme.backgroundNavigationBarColor
        mainView.activityIndicatorView.color = Constants.COLORS.COLOR_BLACK
        navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundNavigationBarColor
    }

    func setupNavigationBar() {
        navigationItem.hidesBackButton = false
        navigationItem.title = name
    }

    private func load() {
        if Reachability.isConnectedToNetwork() == true {
            mainView.activityIndicatorView.startAnimating()
            mainView.activityIndicatorView.isHidden = false
            let url = URL(string: url.trimmingCharacters(in: .whitespaces))
            var request = URLRequest(url: url!)
            if (parameters.count != 0) {
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters!)
                request.addValue("application/json", forHTTPHeaderField: "Content-type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
            }
            webView.load(request)
        } else {
            self.presentAlert(title: NSLocalizedString("ERROR", comment: ""),  message: NSLocalizedString("NO_INTERNET", comment: ""), alertStyle: .alert, actionTitles: [NSLocalizedString("OK", comment: "")], actionStyles: [.default], actions: [
                {_ in
                    self.dismiss(animated: true, completion: nil)
                }
            ])
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if(Float(webView.estimatedProgress) == 1.0 ) {
                mainView.activityIndicatorView.stopAnimating()
                mainView.activityIndicatorView.isHidden = true
            }
        }
    }

    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
