//
//  PayTableFooter.swift
//  VPN
//
//  Created by Сергей on 07.05.2023.
//

import UIKit

class PayTableFooter: UITableViewHeaderFooterView {

    static let identifier = "PayTableFooterId"

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
        label.numberOfLines = 0
        label.text = "\(NSLocalizedString("INFO_CARD", comment: ""))"
        label.font = UIFont(name: "Inter-Regular", size: 13)!
        label.textAlignment = .left
        let text = (label.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: NSLocalizedString("INFO_CARD", comment: ""))
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Constants.COLORS.COLOR_GRAY3_LIGHT, range: range1)
        let range2 = (text as NSString).range(of: NSLocalizedString("AUTOMATIC_CANCELLATION", comment: ""))
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.currentTheme.textTableCellColor, range: range2)
        label.attributedText = underlineAttriString
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
