//
//  UserNotifications.swift
//  WireguardApp
//
//  Created by Сергей on 28.05.2023.
//

import UIKit
import Firebase
import UserNotifications

class UserNotifications: NSObject, MessagingDelegate {

    static let shared = UserNotifications()

    func registerForPushNotifications() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        Storage.setKeyStorage(value: fcmToken!, name: "fcmToken")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        subscribe(to: "ios")
        //unsubscribe(from: "ios")
    }

    func saveRemoteNotification(userInfo: [AnyHashable: Any]) {
        print("saveRemoteNotification: \(userInfo)")
    }

    func subscribe(to topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            print("Subscribed to \(topic) topic")
        }
    }

    func unsubscribe(from topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic)  { error in
            print("Unsubscribed to \(topic) topic")
        }
    }
}


extension UserNotifications: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("userNotificationCenter willPresent notification")
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notification"), object: nil, userInfo: nil)
        //completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("userNotificationCenter didReceive response")
        //completionHandler()
    }

}
