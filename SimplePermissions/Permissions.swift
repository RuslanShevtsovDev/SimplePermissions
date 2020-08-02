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

public typealias PermissionRequestCompletion = ((Permissions.Status) -> Void)

protocol PermissionStatusProtocol {
    var status: Permissions.Status { get }
    var isGranted: Bool { get }
    
    func request(completion: @escaping PermissionRequestCompletion)
}

extension PermissionStatusProtocol {
    var isGranted: Bool {
        status == .granted
    }
}

protocol PermissionKeyProtocol {
    var name: String { get }
    var key: String { get }
    
    func isKeyExist() -> Bool
}

extension PermissionKeyProtocol {
    func isKeyExist() -> Bool {
        if key.isEmpty {
            return true
        }
        
        guard Bundle.main.object(forInfoDictionaryKey: key) != nil else {
            print("Warning!!! - \(key) is missing in Info.plist. Please, add key \(key) to info.plist with description which explains why a user should allow \(name) permission")
            return false
        }
        
        return true
    }
}

protocol PermissionProtocol: PermissionStatusProtocol, PermissionKeyProtocol {
    
}

public class Permissions {
    
    public enum `Type` {
        case microphone
        case camera
        case contacts
        case motion
        case calendar
        case bluetooth
        case notifications
        case speechRecognizer
        case photos
        case locationInUse
        case locationAlways
    }
    
    public enum Status {
        case notDetermined
        case granted
        case denied
    }
    
    public static func status(of permissionType: Type) -> Status {
        let permission = makePermission(type: permissionType)
        guard permission.isKeyExist() else { return .notDetermined }
        
        return permission.status
    }
    
    public static func request(for permissionType: Type, completion: PermissionRequestCompletion? = nil) {
        let permission = restorePermission(type: permissionType)
        guard permission.isKeyExist() else { return }
        
        if permission.status == .granted {
            completion?(.granted)
            return
        }
        
        if permission.status == .denied {
            completion?(.denied)
            return
        }
        
        permission.request(completion: { status in
            removePermission(type: permissionType)
            completion?(status)
        })
    }
    
    // MARK: - Private
    
    private static var permissions: [Type: PermissionProtocol] = { [:] }()
    
    private static func restorePermission(type: Type) -> PermissionProtocol {
        guard let permission = permissions[type] else {
            let permission: PermissionProtocol = makePermission(type: type)
            permissions[type] = permission
            return permission
        }
        
        return permission
    }
    
    private static func removePermission(type: Type) {
        permissions.removeValue(forKey: type)
    }
    
    private static func makePermission(type: Type) -> PermissionProtocol {
        switch type {
        case .microphone:
            return MicrophonePermission()
        case .camera:
            return CameraPermission()
        case .contacts:
            return ContactsPermission()
        case .motion:
            return CoreMotionPermission()
        case .calendar:
            return CalendarPermission()
        case .bluetooth:
            return BluetoothPermission()
        case .notifications:
            return NotificationsPermission()
        case .speechRecognizer:
            return SpeechRecognizerPermission()
        case .photos:
            return PhotosPermission()
        case .locationInUse:
            return LocationInUsePermission()
        case .locationAlways:
            return LocationAlwaysPermission()
        }
    }
}
