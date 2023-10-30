//
//  Pay.swift
//  VPN
//
//  Created by Сергей on 03.05.2023.
//

import UIKit

class Pay {

    var header: String?
    var name: [String]?
    var value: [String]?

    init(header: String?, name: [String]?, value: [String]?) {
        self.header = header
        self.name = name
        self.value = value
    }

    init(payDictionary: [String: AnyObject]) {
        self.header = payDictionary["header"] as? String
        self.name = payDictionary["name"] as? [String]
        self.value = payDictionary["value"] as? [String]
    }

}
