//
//  API.swift
//  VPN
//
//  Created by Сергей on 30.04.2023.
//

import UIKit

class API {

}

extension API {

    static func parseJsonFormData(jsonData: NSData?) -> [String: AnyObject]? {
        if let data = jsonData {
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String: AnyObject]
                return jsonDictionary!
            } catch let error as NSError {
                print("Error processing json data: \(error.localizedDescription))")
            }
        }
        return nil
    }

    static func parseJsonFormDataString(jsonString: String?) -> [String: AnyObject]? {
        if let data = jsonString?.data(using: .utf8) {
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [String: AnyObject]
                return jsonDictionary!
            } catch let error as NSError {
                print("Error processing json data: \(error.localizedDescription))")
            }
        }
        return nil
    }

    static func httpBody(parameters: [String: Any]) -> String {
        var body: [String] = []
        for (key, value) in parameters {
            body.append("\(key)=\(value)")
        }
        let bodyString: String = body.joined(separator: "&")
        return bodyString
    }

    static func load(parameters: [String: Any], completion:@escaping (_ status: Bool, _ items: [LoadAttempt]?) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        var responses = [LoadAttempt]()
        let urlString = "\(Constants.APP.API_URL)\(Constants.API.LOAD)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.timeoutInterval = 5
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("error: \(error!)")
                completion(false, nil)
                return
            } else {
                if let jsonDictionary = API.parseJsonFormData(jsonData: data! as NSData) {
                    print("data: \(jsonDictionary)")
                    let newResponses = LoadAttempt(loadAttemptDictionary: jsonDictionary)
                    responses.append(newResponses)
                }
                completion(true, responses)
            }
        })
        task.resume()
    }

    static func connect(parameters: [String: Any], completion:@escaping (_ status: Bool, _ items: [ConnectAttempt]?) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        var responses = [ConnectAttempt]()
        let urlString = "\(Constants.APP.API_URL)\(Constants.API.CONNECT)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.timeoutInterval = 30
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("error: \(error!)")
                completion(false, nil)
                return
            } else {
                if let jsonDictionary = API.parseJsonFormData(jsonData: data! as NSData) {
                    print("data: \(jsonDictionary)")
                    let newResponses = ConnectAttempt(connectAttemptDictionary: jsonDictionary)
                    responses.append(newResponses)
                }
                completion(true, responses)
            }
        })
        task.resume()
    }

    static func reconnect(parameters: [String: Any], completion:@escaping (_ status: Bool, _ items: [ConnectAttempt]?) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        var responses = [ConnectAttempt]()
        let urlString = "\(Constants.APP.API_URL)\(Constants.API.RECONNECT)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.timeoutInterval = 30
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("error: \(error!)")
                completion(false, nil)
                return
            } else {
                if let jsonDictionary = API.parseJsonFormData(jsonData: data! as NSData) {
                    print("data: \(jsonDictionary)")
                    let newResponses = ConnectAttempt(connectAttemptDictionary: jsonDictionary)
                    responses.append(newResponses)
                }
                completion(true, responses)
            }
        })
        task.resume()
    }

    static func disconnect(parameters: [String: Any], completion:@escaping (_ status: Bool, _ items: [DisconnectAttempt]?) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        var responses = [DisconnectAttempt]()
        let urlString = "\(Constants.APP.API_URL)\(Constants.API.DISCONNECT)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.timeoutInterval = 30
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("error: \(error!)")
                completion(false, nil)
                return
            } else {
                if let jsonDictionary = API.parseJsonFormData(jsonData: data! as NSData) {
                    print("data: \(jsonDictionary)")
                    let newResponses = DisconnectAttempt(disconnectAttemptDictionary: jsonDictionary)
                    responses.append(newResponses)
                }
                completion(true, responses)
            }
        })
        task.resume()
    }

    static func menu(parameters: [String: Any], completion:@escaping (_ status: Bool, _ items: [SettingsAttempt]?) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        var responses = [SettingsAttempt]()
        let urlString = "\(Constants.APP.API_URL)\(Constants.API.MENU)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.timeoutInterval = 30
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("error: \(error!)")
                completion(false, nil)
                return
            } else {
                if let jsonDictionary = API.parseJsonFormData(jsonData: data! as NSData) {
                    print("data: \(jsonDictionary)")
                    let newResponses = SettingsAttempt(settingsAttemptDictionary: jsonDictionary)
                    responses.append(newResponses)
                }
                completion(true, responses)
            }
        })
        task.resume()
    }

    static func payment(parameters: [String: Any], completion:@escaping (_ status: Bool, _ items: [PaymentAttempt]?) -> Void) {
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        var responses = [PaymentAttempt]()
        let urlString = "\(Constants.APP.API_URL)\(Constants.API.PAYMENT)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.timeoutInterval = 30
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("error: \(error!)")
                completion(false, nil)
                return
            } else {
                if let jsonDictionary = API.parseJsonFormData(jsonData: data! as NSData) {
                    print("data: \(jsonDictionary)")
                    let newResponses = PaymentAttempt(paymentAttemptDictionary: jsonDictionary)
                    responses.append(newResponses)
                }
                completion(true, responses)
            }
        })
        task.resume()
    }


}
