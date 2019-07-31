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
    var selectedReminder: NSManagedObject?
    
    var mapViewController: MapViewController?
    
    @IBOutlet weak var reminderDescriptionTextField: UITextField!
    @IBOutlet weak var isEnteringSegementedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReminder(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
        if selectedReminder != nil {
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
        }
    }
    
    @objc func saveReminder(_ sender: Any) {
        var isEnteringStatus: Bool = true
        
        if let reminderDescriptionText = reminderDescriptionTextField.text {
            if isEnteringSegementedControl.selectedSegmentIndex == 0 {
                isEnteringStatus = true
            } else {
                isEnteringStatus = false
            }
            if selectedReminder != nil {
                updateReminder(reminderDescription: reminderDescriptionText, isEntering: isEnteringStatus, reminder: selectedReminder as! Reminder)
            } else {
                saveReminder(reminderDescription: reminderDescriptionText, isEntering: isEnteringStatus)
            }
        }
    }
    
    // MARK: - CoreData Functions
    
    func fetchAllReminders() {
        if let fetchedReminders = CoreDataManager.sharedManager.fetchAllReminders() {
            reminders = fetchedReminders
        }
    }
    
    func saveReminder(reminderDescription: String, isEntering: Bool) {
        if let reminder = CoreDataManager.sharedManager.insertNewReminder(reminderDescription: reminderDescription, isEntering: isEntering) {
            reminders.append(reminder)
        }
        performSegue(withIdentifier: "saveUnwindSegue", sender: self)
    }
    
    func updateReminder(reminderDescription: String, isEntering: Bool, reminder: Reminder) {
        CoreDataManager.sharedManager.updateReminder(reminderDescription: reminderDescription, isEntering: isEntering, reminder: reminder)
        performSegue(withIdentifier: "saveUnwindSegue", sender: self)
    }
    
}

extension ReminderDetailViewController: MapToReminderProtocol {
    func sendDataToReminderVC(data: String) {
        print(data)
    }
}
