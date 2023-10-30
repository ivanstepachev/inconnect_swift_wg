//
//  PayTableCell2.swift
//  VPN
//
//  Created by Сергей on 06.05.2023.
//

import UIKit

class PayTableCell2: UITableViewCell {

    static let identifier = "PayTableCell2Id"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstrants()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let name: UILabel = {
        let label = UILabel()
        label.textColor = Theme.currentTheme.textTableCellColor
        label.textAlignment = .left
        label.contentMode = .center
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular", size: 15)!
        return label
    }()

    func setupViews() {
        addSubview(name)
    }

    func setupConstrants() {
        name.isUserInteractionEnabled = true
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        name.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        name.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
    }
}
