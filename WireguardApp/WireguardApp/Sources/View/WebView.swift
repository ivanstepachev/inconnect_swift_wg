//
//  WebView.swift
//  VPN
//
//  Created by Сергей on 06.05.2023.
//

import UIKit
import WebKit

class WebView: UIView {

    var closeAction: (() -> Void)?

    let webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences
        webConfiguration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.contentMode = .scaleAspectFit
        return webView
    }()

    let activityIndicatorView = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    private func setup() {
        setupViews()
        setupConstrants()
        addActions()
    }

    private func setupViews() {
        self.addSubview(webView)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = true
    }

    private func setupConstrants() {

        webView.isUserInteractionEnabled = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: self.topAnchor, constant: UINavigationController.navBarHeight() + safeAreaTop).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        webView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        webView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true

        activityIndicatorView.isUserInteractionEnabled = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true

    }

    private func addActions() {

    }

}
