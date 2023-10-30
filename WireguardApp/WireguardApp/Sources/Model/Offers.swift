//
//  Offers.swift
//  VPN
//
//  Created by Сергей on 06.05.2023.
//

import UIKit

struct Offers: Codable {

    var offer_id: Int?
    var name: String?
    var price: String?

    init(offer_id: Int?, name: String?, price: String?) {
        self.offer_id = offer_id
        self.name = name
        self.price = price
    }

    init(offersDictionary: [String: AnyObject]) {
        self.offer_id = offersDictionary["offer_id"] as? Int
        self.name = offersDictionary["name"] as? String
        self.price = offersDictionary["price"] as? String
    }

}
