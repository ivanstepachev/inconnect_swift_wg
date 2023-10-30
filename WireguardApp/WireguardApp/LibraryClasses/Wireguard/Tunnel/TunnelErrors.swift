//
//  TunnelErrors.swift
//  WireDemossss
//
//  Created by iOS TL on 13/09/22.
//

import Foundation
import NetworkExtension

enum TunnelsManagerError: WireGuardAppError {
    case tunnelNameEmpty
    case tunnelAlreadyExistsWithThatName
    case systemErrorOnListingTunnels(systemError: Error)
    case systemErrorOnAddTunnel(systemError: Error)
    case systemErrorOnModifyTunnel(systemError: Error)
    case systemErrorOnRemoveTunnel(systemError: Error)

    var alertText: AlertText {
        switch self {
        case .tunnelNameEmpty:
            return ("No name provided", "Cannot create tunnel with an empty name")
        case .tunnelAlreadyExistsWithThatName:
            return ("Name already exists", "A tunnel with that name already exists")
        case .systemErrorOnListingTunnels(let systemError):
            return ("Unable to list tunnels", systemError.localizedUIString)
        case .systemErrorOnAddTunnel(let systemError):
            return ("Unable to create tunnel", systemError.localizedUIString)
        case .systemErrorOnModifyTunnel(let systemError):
            return ("Unable to modify tunnel", systemError.localizedUIString)
        case .systemErrorOnRemoveTunnel(let systemError):
            return ("Unable to remove tunnel", systemError.localizedUIString)
        }
    }
}

enum TunnelsManagerActivationAttemptError: WireGuardAppError {
    case tunnelIsNotInactive
    case failedWhileStarting(systemError: Error) // startTunnel() throwed
    case failedWhileSaving(systemError: Error) // save config after re-enabling throwed
    case failedWhileLoading(systemError: Error) // reloading config throwed
    case failedBecauseOfTooManyErrors(lastSystemError: Error) // recursion limit reached

    var alertText: AlertText {
        switch self {
        case .tunnelIsNotInactive:
            return ("Activation in progress", "The tunnel is already active or in the process of being activated")
        case .failedWhileStarting(let systemError),
             .failedWhileSaving(let systemError),
             .failedWhileLoading(let systemError),
             .failedBecauseOfTooManyErrors(let systemError):
            return ("Activation failure", "The tunnel could not be activated. \(systemError.localizedUIString)")
        }
    }
}

enum TunnelsManagerActivationError: WireGuardAppError {
    case activationFailed(wasOnDemandEnabled: Bool)
    case activationFailedWithExtensionError(title: String, message: String, wasOnDemandEnabled: Bool)

    var alertText: AlertText {
        switch self {
        case .activationFailed:
            return ("Activation failure", "The tunnel could not be activated. Please ensure that you are connected to the Internet.")
        case .activationFailedWithExtensionError(let title, let message, _):
            return (title, message)
        }
    }
}

extension PacketTunnelProviderError: WireGuardAppError {
    var alertText: AlertText {
        switch self {
        case .savedProtocolConfigurationIsInvalid:
            return ("Activation failure", "Unable to retrieve tunnel information from the saved configuration.")
        case .dnsResolutionFailure:
            return ("DNS resolution failure", "One or more endpoint domains could not be resolved.")
        case .couldNotStartBackend:
            return ("Activation failure", "Unable to turn on Go backend library.")
        case .couldNotDetermineFileDescriptor:
            return ("Activation failure", "Unable to determine TUN device file descriptor.")
        case .couldNotSetNetworkSettings:
            return ("Activation failure", "Unable to apply network settings to tunnel object.")
        }
    }
}

extension Error {
    var localizedUIString: String {
        if let systemError = self as? NEVPNError {
            switch systemError {
            case NEVPNError.configurationInvalid:
                return "The configuration is invalid."
            case NEVPNError.configurationDisabled:
                return "The configuration is disabled."
            case NEVPNError.connectionFailed:
                return "The connection failed."
            case NEVPNError.configurationStale:
                return "The configuration is stale."
            case NEVPNError.configurationReadWriteFailed:
                return "Reading or writing the configuration failed."
            case NEVPNError.configurationUnknown:
                return "Unknown system error."
            default:
                return ""
            }
        } else {
            return localizedDescription
        }
    }
}
