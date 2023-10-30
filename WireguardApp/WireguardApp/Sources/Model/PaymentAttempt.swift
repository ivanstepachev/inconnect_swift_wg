//
//  PaymentAttempt.swift
//  VPN
//
//  Created by Сергей on 02.05.2023.
//

import UIKit

struct PaymentAttempt: Codable {

    var policy: String?
    var payment_link: String?
    var offers: [Offers]?
    var buttons: [Buttons]?
    var recurrent: Bool?
    var recurrent_offer: String?
    var offer: String?

    private enum CodingKeys : CodingKey {
        case policy, payment_link, offers, buttons, recurrent, recurrent_offer, offer
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.policy = try container.decode(String.self, forKey: .policy)
        self.payment_link = try container.decode(String.self, forKey: .payment_link)
        self.offers = try container.decodeIfPresent([Offers].self, forKey: .offers)
        self.buttons = try container.decodeIfPresent([Buttons].self, forKey: .buttons)
        self.recurrent = try container.decode(Bool.self, forKey: .recurrent)
        self.recurrent_offer = try container.decode(String.self, forKey: .recurrent_offer)
        self.offer = try container.decode(String.self, forKey: .offer)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(policy, forKey: .policy)
        try container.encode(payment_link, forKey: .payment_link)
        try container.encode(offers, forKey: .offers)
        try container.encode(buttons, forKey: .buttons)
        try container.encode(recurrent, forKey: .recurrent)
        try container.encode(recurrent_offer, forKey: .recurrent_offer)
        try container.encode(offer, forKey: .offer)
    }

    init(policy: String?, payment_link: String?, offers: [Offers]?, buttons: [Buttons]?, recurrent: Bool?, recurrent_offer: String?, offer: String?) {
        self.policy = policy
        self.payment_link = payment_link
        self.offers = offers
        self.buttons = buttons
        self.recurrent = recurrent
        self.recurrent_offer = recurrent_offer
        self.offer = offer
    }

    init(paymentAttemptDictionary: [String: AnyObject]) {
        self.policy = paymentAttemptDictionary["policy"] as? String
        self.payment_link = paymentAttemptDictionary["payment_link"] as? String
        if (paymentAttemptDictionary["offers"] != nil) {
            var offers = [Offers]()
            let offersDictionaries = paymentAttemptDictionary["offers"] as! [[String: AnyObject]]
            for offersDictionary in offersDictionaries {
                let newResponses = Offers(offersDictionary: offersDictionary)
                offers.append(newResponses)
            }
            self.offers = offers
        }
        if (paymentAttemptDictionary["buttons"] != nil) {
            var buttons = [Buttons]()
            let buttonsDictionaries = paymentAttemptDictionary["buttons"] as! [[String: AnyObject]]
            for buttonsDictionary in buttonsDictionaries {
                let newResponses = Buttons(buttonsDictionary: buttonsDictionary)
                buttons.append(newResponses)
            }
            self.buttons = buttons
        }
        self.recurrent = paymentAttemptDictionary["recurrent"] as? Bool
        self.recurrent_offer = paymentAttemptDictionary["recurrent_offer"] as? String
        self.offer = paymentAttemptDictionary["offer"] as? String
    }
}

