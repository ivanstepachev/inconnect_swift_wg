//
//  SettingsView.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import UIKit

class SettingsView: UIView {

    let refreshControl = UIRefreshControl()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsTableHeader.self, forHeaderFooterViewReuseIdentifier: SettingsTableHeader.identifier)
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
        //tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Theme.currentTheme.backgroundTableColor
        return tableView
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
        backgroundColor = Constants.COLORS.COLOR_WHITE
        self.addSubview(tableView)
        tableView.addSubview(refreshControl)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = true
        refreshControl.tintColor = Theme.currentTheme.textTableCellColor
        activityIndicatorView.color = Theme.currentTheme.textTableCellColor
    }

    private func setupConstrants() {

        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true

        activityIndicatorView.isUserInteractionEnabled = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }

    private func addActions() {

    }

}
