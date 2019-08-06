//
//  CoreLocationManager.swift
//  ReminderApp
//
//  Created by Mike Conner on 8/3/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class CoreLocationManager: NSObject {
    
    let geoFenceRadius = 50.0  // in meters
    
    let center = UNUserNotificationCenter.current()
    
    let locationManager = CLLocationManager()
    var lastLocation = CLLocation()
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static let sharedLocationManager = CoreLocationManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("notification permission granted!")
            }
        }
        print(locationManager.monitoredRegions.count)
        for fence in locationManager.monitoredRegions {
            print(fence.description)
        }
        
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
            addTrigger(for: geoFenceRegion)
        } else {
            print("too many geofences created!")
        }
    }
    
    func removeGeoFence(for region: CLRegion) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == region.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func handleEvent(for region: CLRegion) {
        
    }
    
    func addTrigger(for region: CLRegion) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder:"
        content.body = locationManager.monitoredRegions.description
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        addRequestToNotificationCenter(for: trigger, with: content)
    }

    func addRequestToNotificationCenter(for trigger: UNLocationNotificationTrigger, with content: UNMutableNotificationContent) {
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request) { (error) in
            print("Error adding request: \(String(describing: error))")
        }
    }
    
}

extension CoreLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last { lastLocation = last }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("did fail with error")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print("authorization changed")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("did enter region")
//        handleEvent(for: region)
//        removeGeoFence(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("did exit region")
//        handleEvent(for: region)
//        removeGeoFence(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print(region.description)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
}
