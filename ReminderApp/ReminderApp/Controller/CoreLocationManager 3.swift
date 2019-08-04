//
//  CoreLocationManager.swift
//  ReminderApp
//
//  Created by Mike Conner on 8/3/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import UIKit
import CoreLocation

class CoreLocationManager: NSObject {
    
    let geoFenceRadius = 50.0  // in meters
    
    let locationManager = CLLocationManager()
    var lastLocation = CLLocation()
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static let sharedLocationManager = CoreLocationManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }    
    
    func createGeoFence(lat: Double, lon: Double, identifier: String, onEntry: Bool) {
        if locationManager.monitoredRegions.count < 20 {
            let geoFenceRegionCenter = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let geoFenceRegion = CLCircularRegion(center: geoFenceRegionCenter, radius: geoFenceRadius, identifier: identifier)
            if onEntry {
                geoFenceRegion.notifyOnEntry = true
                geoFenceRegion.notifyOnExit = false
            } else {
                geoFenceRegion.notifyOnEntry = false
                geoFenceRegion.notifyOnExit = true
            }
            locationManager.startMonitoring(for: geoFenceRegion)
            print(locationManager.monitoredRegions.count)
            print(geoFenceRegion.description)
        } else {
            print("too many geofences created!")
        }
    }
}

extension CoreLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last { lastLocation = last }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("did fail with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            print("authorization changed")
        } else {
            print("Always Authorization must be chosen to work properly")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // do something
    }
    
}
