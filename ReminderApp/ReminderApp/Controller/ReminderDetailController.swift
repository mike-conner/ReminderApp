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
    
    
    
    @IBOutlet weak var reminderDescriptionTextField: UITextField!
    @IBOutlet weak var isEnteringSegementedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReminder(_:)))
        navigationItem.rightBarButtonItem = saveButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllReminders()
    }
    
    @objc func saveReminder(_ sender: Any) {
        var isEnteringStatus: Bool = true
        if reminderDescriptionTextField.text != "" {
            if isEnteringSegementedControl.tag == 0 {
                isEnteringStatus = true
            } else {
                isEnteringStatus = false
            }
            saveReminder(reminderDescription: description, isEntering: isEnteringStatus)
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
    }
    
    
}

