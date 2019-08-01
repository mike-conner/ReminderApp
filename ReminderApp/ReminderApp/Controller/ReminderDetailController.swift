//
//  ReminderDetailController.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/24/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import UIKit
import CoreData

//protocol ReminderToMapProtocol {
//    func sendDataToMapVC(latitude: Double, longitude: Double)
//}


class ReminderDetailViewController: UIViewController {
    
    var reminders: [NSManagedObject] = []
    var selectedReminder: NSManagedObject?
    
    var locationName: String?
    var locationLatitude: Double?
    var locationLongitude: Double?
    
    var mapViewController: MapViewController?
    
    @IBOutlet weak var reminderDescriptionTextField: UITextField!
    @IBOutlet weak var isEnteringSegementedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReminder(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        if selectedReminder != nil {
            locationLatitude = selectedReminder?.value(forKey: "reminderLatitude") as? Double
            locationLongitude = selectedReminder?.value(forKey: "reminderLongitude") as? Double

            reminderDescriptionTextField.text = selectedReminder?.value(forKey: "reminderDescription") as? String
            if selectedReminder?.value(forKey: "isEntering") as! Bool == true {
                isEnteringSegementedControl.selectedSegmentIndex = 0
            } else {
                isEnteringSegementedControl.selectedSegmentIndex = 1
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllReminders()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapSegue" {
            let destinationViewController = segue.destination as! UINavigationController
            let targetViewController = destinationViewController.topViewController as! MapViewController
            targetViewController.mapToReminder = self
            if selectedReminder != nil {
                locationLatitude = selectedReminder?.value(forKey: "reminderLatitude") as? Double
                locationLongitude = selectedReminder?.value(forKey: "reminderLongitude") as? Double
                locationName = selectedReminder?.value(forKey: "reminderLocation") as? String
            }
            if let lat = locationLatitude, let lon = locationLongitude, let name = locationName {
                targetViewController.locationLatitude = lat
                targetViewController.locationLongitude = lon
                targetViewController.locationName = name
            }
        }
    }
    
    @objc func saveReminder(_ sender: Any) {
        var isEnteringStatus: Bool = true
        
        if let reminderDescriptionText = reminderDescriptionTextField.text, let name = locationName, let lat = locationLatitude, let lon = locationLongitude {
            if isEnteringSegementedControl.selectedSegmentIndex == 0 {
                isEnteringStatus = true
            } else {
                isEnteringStatus = false
            }
            if selectedReminder != nil {
                updateReminder(reminderDescription: reminderDescriptionText, reminderLocation: name, isEntering: isEnteringStatus, reminderLatitude: lat, reminderLongitude: lon, reminder: selectedReminder as! Reminder)
            } else {
                saveReminder(reminderDescription: reminderDescriptionText, reminderLocation: name, isEntering: isEnteringStatus, reminderLatitude: lat, reminderLongitude: lon)
            }
        }
    }
    
    // MARK: - CoreData Functions
    
    func fetchAllReminders() {
        if let fetchedReminders = CoreDataManager.sharedManager.fetchAllReminders() {
            reminders = fetchedReminders
        }
    }
    
    func saveReminder(reminderDescription: String, reminderLocation: String, isEntering: Bool, reminderLatitude: Double, reminderLongitude: Double) {
        if let reminder = CoreDataManager.sharedManager.insertNewReminder(reminderDescription: reminderDescription, reminderLocation: reminderLocation, isEntering: isEntering, reminderLatitude: reminderLatitude, reminderLongitude: reminderLongitude) {
            reminders.append(reminder)
        }
        performSegue(withIdentifier: "saveUnwindSegue", sender: self)
    }
    
    func updateReminder(reminderDescription: String, reminderLocation: String, isEntering: Bool, reminderLatitude: Double, reminderLongitude: Double, reminder: Reminder) {
        CoreDataManager.sharedManager.updateReminder(reminderDescription: reminderDescription, reminderLocation: reminderLocation, isEntering: isEntering, reminderLatitude: reminderLatitude, reminderLongitude: reminderLongitude, reminder: reminder)
        performSegue(withIdentifier: "saveUnwindSegue", sender: self)
    }
    
}

extension ReminderDetailViewController: MapToReminderProtocol {
    func sendDataToReminderVC(name: String, latitude: Double, longitude: Double) {
        locationName = name
        locationLatitude = latitude
        locationLongitude = longitude
    }
}
