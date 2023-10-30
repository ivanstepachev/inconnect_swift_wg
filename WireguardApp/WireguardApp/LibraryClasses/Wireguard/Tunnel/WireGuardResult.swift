//
//  WireGuardResult.swift
//  WireDemossss
//
//  Created by iOS TL on 13/09/22.
//

import Foundation

enum WireGuardResult<T> {
    case success(_ value: T)
    case failure(_ error: WireGuardAppError)

    var value: T? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }

    var error: WireGuardAppError? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }

    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}
