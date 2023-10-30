//
//  String.swift
//  WireguardApp
//
//  Created by Сергей on 07.06.2023.
//

import Foundation

extension String {

    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }

    func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

}
