//
//  WireGuardAppError.swift
//  WireDemossss
//
//  Created by iOS TL on 13/09/22.
//

import Foundation

protocol WireGuardAppError: Error {
    typealias AlertText = (title: String, message: String)

    var alertText: AlertText { get }
}
