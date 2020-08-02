//    The MIT License (MIT)
//
//    Copyright (c) 2020 Ruslan Shevtsov
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import Foundation
import UIKit

final class NotificationsPermission: PermissionProtocol {
    var name: String {
        "Push Notifications"
    }
    
    var key: String {
        ""
    }
    
    func isKeyExist() -> Bool {
        guard let modes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] else {
            print("Warning!!! - UIBackgroundModes for remote-notification is missing in Info.plist. Please, add key remote-notification to info.plist with description which explains why a user should allow \(name) permission")
            return false
        }
        
        for mode in modes {
            if mode == "remote-notification" {
                return true
            }
        }
        
        print("Warning!!! - UIBackgroundModes for remote-notification is missing in Info.plist. Please, add key remote-notification to info.plist with description which explains why a user should allow \(name) permission")
        return false
    }
    
    var status: Permissions.Status {
        var notificationSettings: UNNotificationSettings?
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            UNUserNotificationCenter.current().getNotificationSettings { setttings in
                notificationSettings = setttings
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        switch notificationSettings?.authorizationStatus {
        case .notDetermined, .none:
            return .notDetermined
        case .denied:
            return .denied
        case .authorized, .provisional:
            return .granted
        @unknown default:
            return .notDetermined
        }
    }
    
    func request(completion: @escaping PermissionRequestCompletion) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { granted, _ in
            if granted {
                completion(.granted)
            } else {
                completion(.denied)
            }
        }
    }
}
