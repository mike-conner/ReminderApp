//
//  ReminderDetailController.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/24/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import UIKit
import CoreData

class ReminderDetailViewController: UIViewController {
    
    var reminders: [NSManagedObject] = []
    var selectedReminder: NSManagedObject? // when a row is selected on the MasterVC, the Reminder object is passed to the ReminderDetailVC and stored in this variable
    
    // the below variables are used to store the information passed back from the MapViewVC
    var locationName: String?
    var locationLatitude: Double?
    var locationLongitude: Double?
    
    var mapViewController: MapViewController?
    
    @IBOutlet weak var reminderDescriptionTextField: UITextField!
    @IBOutlet weak var isEnteringSegementedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // below two lines create a save button for the ReminderDetailVC
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReminder(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // perform the below block only if viewing an existing reminder, if creating a new reminder 'selectedReminder' will be nil
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
    
    // if an existing reminder is selected on master, the below block sends the necessary information to populate the map with the correct location data
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
        // only save if reminderDescriptionTextField has information and a location has been selected or is already populated (i.e., viewing a previously made reminder)
        guard let description = reminderDescriptionTextField.text else { return }
        if description != "" && description != " " {
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
        performSegue(withIdentifier: "saveUnwindSegue", sender: self) // unwind to masterVC after save reminder has been called
    }
    
    func updateReminder(reminderDescription: String, reminderLocation: String, isEntering: Bool, reminderLatitude: Double, reminderLongitude: Double, reminder: Reminder) {
        CoreDataManager.sharedManager.updateReminder(reminderDescription: reminderDescription, reminderLocation: reminderLocation, isEntering: isEntering, reminderLatitude: reminderLatitude, reminderLongitude: reminderLongitude, reminder: reminder)
        performSegue(withIdentifier: "saveUnwindSegue", sender: self) // unwind to masterVC after update Reminder has been called
    }
    
}

// below extension used to conform to delegate 'MapToReminderProtocol' to allow map data to be received from the MapVC
extension ReminderDetailViewController: MapToReminderProtocol {
    func sendDataToReminderVC(name: String, latitude: Double, longitude: Double) {
        locationName = name
        locationLatitude = latitude
        locationLongitude = longitude
    }
}


