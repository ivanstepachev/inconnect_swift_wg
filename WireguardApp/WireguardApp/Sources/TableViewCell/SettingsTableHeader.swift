//
//  SettingsTableHeader.swift
//  VPN
//
//  Created by Сергей on 01.05.2023.
//

import UIKit

class SettingsTableHeader: UITableViewHeaderFooterView {

    static let identifier = "SettingsTableHeaderId"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstrants()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let title: UILabel = {
        let label = UILabel()
        label.textColor = Constants.COLORS.COLOR_GRAY3_LIGHT
        label.textAlignment = .left
        label.contentMode = .center
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular", size: 17)!
        return label
    }()

    func setupViews() {
        contentView.addSubview(title)
    }

    func setupConstrants() {
        title.isUserInteractionEnabled = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
    }
}
