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
import CoreBluetooth

final class BluetoothPermission: NSObject, PermissionProtocol {
    
    private var peripheralManager: CBPeripheralManager?
    private var completion: PermissionRequestCompletion?
    
    var name: String {
        "Bluetooth"
    }
    
    var key: String {
        "NSBluetoothAlwaysUsageDescription"
    }
    
    var status: Permissions.Status {
        if #available(iOS 13.1, *) {
            switch CBPeripheralManager.authorization {
            case .notDetermined, .restricted:
                return .notDetermined
            case .denied:
                return .denied
            case .allowedAlways:
                return .granted
            @unknown default:
                return .notDetermined
            }
        } else {
            switch CBPeripheralManager().authorization {
            case .notDetermined, .restricted:
                return .notDetermined
            case .denied:
                return .denied
            case .allowedAlways:
                return .granted
            @unknown default:
                return .notDetermined
            }
        }
    }
    
    override init() {
        super.init()
        
        peripheralManager = CBPeripheralManager(delegate: self,
                                                queue: nil,
                                                options: [CBPeripheralManagerOptionShowPowerAlertKey: false])
    }
    
    func request(completion: @escaping PermissionRequestCompletion) {
        self.completion = completion
        
        peripheralManager?.startAdvertising(nil)
        peripheralManager?.stopAdvertising()
    }
}

extension BluetoothPermission: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if #available(iOS 13.1, *) {
            if CBPeripheralManager.authorization == .allowedAlways {
                completion?(.granted)
            } else {
                completion?(.denied)
            }
        } else {
            if CBPeripheralManager().authorization == .allowedAlways {
                completion?(.granted)
            } else {
                completion?(.denied)
            }
        }
    }
}
