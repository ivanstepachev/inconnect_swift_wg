//
//  HomeView.swift
//  VPN
//
//  Created by Сергей on 28.04.2023.
//

import UIKit

class HomeView: UIView {

    var menuAction: (() -> Void)?
    var payAction: (() -> Void)?

    let menu_button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Theme.currentTheme.menuImage.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.masksToBounds = false
        button.clipsToBounds = false
        return button
    }()

    let status: UILabel = {
        let label = UILabel()
        label.textColor = Theme.currentTheme.statusLightColor
        label.numberOfLines = 0
        label.text = "\(NSLocalizedString("DISABLED", comment: ""))"
        label.font = UIFont(name: "Inter-Regular", size: 15)!
        label.textAlignment = .center
        return label
    }()

    let indicator: CustomIndicator = {
        let spinner = CustomIndicator(squareLength: 28)
        return spinner
    }()

    let time: UILabel = {
        let label = UILabel()
        label.textColor = Theme.currentTheme.timeLightColor
        label.numberOfLines = 0
        label.text = "00:00:00"
        label.font = UIFont(name: "Inter-Bold", size: 32)!
        label.textAlignment = .center
        return label
    }()

    var my_switch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        customSwitch.onTintColor = Theme.currentTheme.switchOnTintColor
        customSwitch.offTintColor = Theme.currentTheme.switchOffTintColor
        customSwitch.cornerRadius = 0.5
        customSwitch.thumbCornerRadius = 0.5
        customSwitch.thumbTintColor = Theme.currentTheme.switchThumbTintColor
        customSwitch.animationDuration = 0.25
        customSwitch.thumbSize = CGSize(width: 76, height: 76)
        customSwitch.padding = 6
        customSwitch.thumbShadowColor = .clear
        return customSwitch
    }()

    let activityIndicatorView = UIActivityIndicatorView(style: .medium)

    let pay_button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Theme.currentTheme.cardImage.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets.left = -15
        button.backgroundColor = Theme.currentTheme.buttonBackgroundColor
        button.setAttributedTitle(NSAttributedString(string: NSLocalizedString("TO_PAY_SUBSCRIPTION", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : Theme.currentTheme.buttonTextColor, NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 17)!]), for: .normal)
        button.layer.cornerRadius = 27.5
        button.layer.masksToBounds = false
        button.clipsToBounds = false
        return button
    }()

    let subscription_days: UILabel = {
        let label = UILabel()
        label.textColor = Theme.currentTheme.subscriptionColor
        label.numberOfLines = 0
        label.text = "\(NSLocalizedString("ACTIVATE_SUBSCRIPTION", comment: ""))"
        label.font = UIFont(name: "Inter-Regular", size: 14)!
        label.textAlignment = .center
        return label
    }()

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
        backgroundColor = Theme.currentTheme.backgroundColor
        self.addSubview(menu_button)
        self.addSubview(status)
        self.addSubview(time)
        self.addSubview(indicator)
        self.addSubview(my_switch)
        self.addSubview(pay_button)
        self.addSubview(subscription_days)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = true
    }

    private func setupConstrants() {

        menu_button.isUserInteractionEnabled = true
        menu_button.translatesAutoresizingMaskIntoConstraints = false
        menu_button.topAnchor.constraint(equalTo: self.topAnchor, constant: safeAreaTop + 24).isActive = true
        menu_button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24).isActive = true
        menu_button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menu_button.heightAnchor.constraint(equalToConstant: 24).isActive = true

        status.isUserInteractionEnabled = true
        status.translatesAutoresizingMaskIntoConstraints = false
        status.bottomAnchor.constraint(equalTo: time.topAnchor, constant: -8).isActive = true
        status.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        status.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true

        time.isUserInteractionEnabled = true
        time.translatesAutoresizingMaskIntoConstraints = false
        time.bottomAnchor.constraint(equalTo: my_switch.topAnchor, constant: -24).isActive = true
        time.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        time.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true

        indicator.isUserInteractionEnabled = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 14).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 28).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 28).isActive = true

        my_switch.isUserInteractionEnabled = true
        my_switch.translatesAutoresizingMaskIntoConstraints = false
        my_switch.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        my_switch.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        my_switch.widthAnchor.constraint(equalToConstant: 172).isActive = true
        my_switch.heightAnchor.constraint(equalToConstant: 88).isActive = true

        activityIndicatorView.isUserInteractionEnabled = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicatorView.topAnchor.constraint(equalTo: my_switch.bottomAnchor, constant: 20).isActive = true

        pay_button.isUserInteractionEnabled = true
        pay_button.translatesAutoresizingMaskIntoConstraints = false
        pay_button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -75).isActive = true
        pay_button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 48).isActive = true
        pay_button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -48).isActive = true
        pay_button.heightAnchor.constraint(equalToConstant: 56).isActive = true

        subscription_days.isUserInteractionEnabled = true
        subscription_days.translatesAutoresizingMaskIntoConstraints = false
        subscription_days.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -31).isActive = true
        subscription_days.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        subscription_days.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }

    private func addActions() {
        menu_button.addTarget(self, action: #selector(self.onMenu), for: .touchUpInside)
        pay_button.addTarget(self, action: #selector(self.onPay), for: .touchUpInside)
    }

    @objc func onPay() {
        payAction?()
    }

    @objc func onMenu() {
        menuAction?()
    }
}
