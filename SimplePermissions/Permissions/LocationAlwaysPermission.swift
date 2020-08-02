//
//  LocationAlwaysPermission.swift
//  SimplePermissions
//
//  Created by Ruslan on 28.06.2020.
//  Copyright © 2020 rshevtsovdev. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationAlwaysPermission: NSObject, PermissionProtocol {
    private var locationManager: CLLocationManager?
    private var completion: PermissionRequestCompletion?
    
    var name: String {
        "Location In Use"
    }
    
    var key: String {
        "NSLocationAlwaysUsageDescription"
    }
    
    var status: Permissions.Status {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .authorizedWhenInUse:
            return .notDetermined
        case .denied:
            return .denied
        case .authorizedAlways:
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

extension LocationAlwaysPermission: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            completion?(.granted)
        } else {
            completion?(.denied)
        }
    }
}
