//
//  PayTableCell.swift
//  VPN
//
//  Created by Сергей on 03.05.2023.
//

import UIKit

class PayTableCell: UITableViewCell {

    static let identifier = "PayTableCellId"

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

    let value: UILabel = {
        let label = UILabel()
        label.textColor = Constants.COLORS.COLOR_GRAY3_LIGHT
        label.textAlignment = .right
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular", size: 16)!
        return label
    }()

    func setupViews() {
        addSubview(name)
        addSubview(value)
    }

    func setupConstrants() {
        name.isUserInteractionEnabled = true
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        name.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        name.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true

        value.isUserInteractionEnabled = true
        value.translatesAutoresizingMaskIntoConstraints = false
        value.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        value.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        value.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -46).isActive = true
    }
}
