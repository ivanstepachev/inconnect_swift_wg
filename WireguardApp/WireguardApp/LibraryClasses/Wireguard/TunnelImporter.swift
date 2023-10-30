//
//  TunnelImporter.swift
//  WireDemossss
//
//  Created by iOS TL on 13/09/22.
//

import Foundation
import UIKit

class TunnelImporter {
    static func importFromFile(urls: [URL], into tunnelsManager: TunnelsManager, sourceVC: AnyObject?, errorPresenterType: ErrorPresenterProtocol.Type, completionHandler: (() -> Void)? = nil) {
        guard !urls.isEmpty else {
            completionHandler?()
            return
        }
        let dispatchGroup = DispatchGroup()
        var configs = [TunnelConfiguration?]()
        var lastFileImportErrorText: (title: String, message: String)?
        for url in urls {
            if url.pathExtension.lowercased() == "zip" {
                dispatchGroup.enter()
                ZipImporter.importConfigFiles(from: url) { result in
                    switch result {
                    case .failure(let error):
                        lastFileImportErrorText = error.alertText
                    case .success(let configsInZip):
                        configs.append(contentsOf: configsInZip)
                    }
                    dispatchGroup.leave()
                }
            } else { /* if it is not a zip, we assume it is a conf */
                let fileName = url.lastPathComponent
                let fileBaseName = url.deletingPathExtension().lastPathComponent.trimmingCharacters(in: .whitespacesAndNewlines)
                dispatchGroup.enter()
                DispatchQueue.global(qos: .userInitiated).async {
                    let fileContents: String
                    do {
                        fileContents = try String(contentsOf: url)
                    } catch let error {
                        DispatchQueue.main.async {
                            if let cocoaError = error as? CocoaError, cocoaError.isFileError {
                                lastFileImportErrorText = (title: "Unable to import from file", message: error.localizedDescription)
                            } else {
                                lastFileImportErrorText = (title: "Unable to import from file", message: "The file \(fileName) could not be read.")
                            }
                            configs.append(nil)
                            dispatchGroup.leave()
                        }
                        return
                    }
                    var parseError: Error?
                    var tunnelConfiguration: TunnelConfiguration?
                    do {
                        tunnelConfiguration = try TunnelConfiguration(fromWgQuickConfig: fileContents, called: fileBaseName)
                    } catch let error {
                        parseError = error
                    }
                    DispatchQueue.main.async {
                        if parseError != nil {
                            if let parseError = parseError as? WireGuardAppError {
                                lastFileImportErrorText = parseError.alertText
                            } else {
                                lastFileImportErrorText = (title: "Unable to import tunnel", message: "The file \(fileName) does not contain a valid WireGuard configuration")
                            }
                        }
                        configs.append(tunnelConfiguration)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            tunnelsManager.addMultiple(tunnelConfigurations: configs.compactMap { $0 }) { numberSuccessful, lastAddError in
                if !configs.isEmpty && numberSuccessful == configs.count {
                    completionHandler?()
                    return
                }
                let alertText: (title: String, message: String)?
                if urls.count == 1 {
                    if urls.first!.pathExtension.lowercased() == "zip" && !configs.isEmpty {
                        alertText = (title: "Created \(numberSuccessful) tunnels",
                                     message: "Created \(numberSuccessful) of \(configs.count) tunnels from zip archive")
                    } else {
                        alertText = lastFileImportErrorText ?? lastAddError?.alertText
                    }
                } else {
                    alertText = (title: "Created \(numberSuccessful) tunnels",
                                 message: "Created \(numberSuccessful) of \(configs.count) tunnels from imported files")
                }
                if let alertText = alertText {
//                    errorPresenterType.showErrorAlert(title: alertText.title, message: alertText.message, from: sourceVC, onPresented: completionHandler)
                } else {
                    completionHandler?()
                }
            }
        }
    }
}

protocol ErrorPresenterProtocol {
    static func showErrorAlert(title: String, message: String, from sourceVC: AnyObject?, onPresented: (() -> Void)?, onDismissal: (() -> Void)?)
}

extension ErrorPresenterProtocol {
    static func showErrorAlert(title: String, message: String, from sourceVC: AnyObject?, onPresented: (() -> Void)?) {
        showErrorAlert(title: title, message: message, from: sourceVC, onPresented: onPresented, onDismissal: nil)
    }

    static func showErrorAlert(title: String, message: String, from sourceVC: AnyObject?, onDismissal: (() -> Void)?) {
        showErrorAlert(title: title, message: message, from: sourceVC, onPresented: nil, onDismissal: onDismissal)
    }

    static func showErrorAlert(title: String, message: String, from sourceVC: AnyObject?) {
        showErrorAlert(title: title, message: message, from: sourceVC, onPresented: nil, onDismissal: nil)
    }

    static func showErrorAlert(error: WireGuardAppError, from sourceVC: AnyObject?, onPresented: (() -> Void)? = nil, onDismissal: (() -> Void)? = nil) {
        let (title, message) = error.alertText
        showErrorAlert(title: title, message: message, from: sourceVC, onPresented: onPresented, onDismissal: onDismissal)
    }
}



class ErrorPresenter: ErrorPresenterProtocol {
    static func showErrorAlert(title: String, message: String, from sourceVC: AnyObject?, onPresented: (() -> Void)?, onDismissal: (() -> Void)?) {
        guard let sourceVC = sourceVC as? UIViewController else { return }

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            onDismissal?()
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)

        sourceVC.present(alert, animated: true, completion: onPresented)
    }
}
