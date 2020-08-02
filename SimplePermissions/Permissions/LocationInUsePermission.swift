//
//  LocationInUsePermission.swift
//  SimplePermissions
//
//  Created by Ruslan on 28.06.2020.
//  Copyright © 2020 rshevtsovdev. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationInUsePermission: NSObject, PermissionProtocol {
    private var locationManager: CLLocationManager?
    private var completion: PermissionRequestCompletion?
    
    var name: String {
        "Location In Use"
    }
    
    var key: String {
        "NSLocationWhenInUseUsageDescription"
    }
    
    var status: Permissions.Status {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted:
            return .notDetermined
        case .denied:
            return .denied
        case .authorizedWhenInUse, .authorizedAlways:
            return .granted
        @unknown default:
            return .notDetermined
        }
    }
    
    override init() {
        locationManager = CLLocationManager()
    }
    
    func request(completion: @escaping PermissionRequestCompletion) {
        self.completion = completion
        
        locationManager?.requestWhenInUseAuthorization()
    }
}

extension LocationInUsePermission: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            completion?(.granted)
        } else {
            completion?(.denied)
        }
    }
}
