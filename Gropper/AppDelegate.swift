//
//  AppDelegate.swift
//  Gropper
//
//  Created by Bryce King on 1/9/26.
//

import Foundation
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let userToken = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("Device Token:", userToken)
        guard let userPhone = getItem(forKey: "userPhoneNumber") else {
            print("no phone number")
            return
        }
        Task {
            do {
                let request = Authentication.allowNotifications(phoneNumber: userPhone, token: userToken)
                try await NetworkManager.shared.execute(endpoint: request, auth: true, type: Bool.self)
                
            } catch {
                print("error:", error)
            }
        }
    }
}
