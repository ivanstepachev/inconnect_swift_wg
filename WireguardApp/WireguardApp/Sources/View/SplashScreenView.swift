//
//  SplashScreenView.swift
//  WireguardApp
//
//  Created by Сергей on 22.05.2023.
//

import UIKit

class SplashScreenView: UIView {

    let logo: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let name: UILabel = {
        let label = UILabel()
        label.textColor = Theme.currentTheme.splashNameColor
        label.numberOfLines = 0
        label.text = Constants.APP.NAME
        label.font = UIFont(name: "KronaOne-Regular", size: 24)!
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
        self.addSubview(logo)
        self.addSubview(name)
    }

    private func setupConstrants() {
        logo.isUserInteractionEnabled = true
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        logo.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -25).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 100).isActive = true

        name.isUserInteractionEnabled = true
        name.translatesAutoresizingMaskIntoConstraints = false
        name.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        name.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        name.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }

    private func addActions() {

    }
}

