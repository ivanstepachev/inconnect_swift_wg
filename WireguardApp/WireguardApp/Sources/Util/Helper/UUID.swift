//
//  UUID.swift
//  VPN
//
//  Created by Сергей on 09.05.2023.
//

import UIKit

class UniqueUUID {

    static func getUUID() -> String? {

        let keychain = KeychainAccess()

        let uuidKey = "ru.ntens.connect.unique_uuid"

        if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey), uuid != nil {
            return uuid
        }

        guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }

        print("-->\(newId)")

        try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)

        return newId
    }

}
