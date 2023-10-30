//
//  Storage.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import Foundation

class Storage {

    static func getKeyStorage(name: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: name)
    }

    static func getKeyStorage<T>(name: String, type: T.Type) -> T? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: name) as? T
    }

    static func setKeyStorage(value: Any, name: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: name)
    }

    static func removeKeyStorage(name: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: name)
    }
}
