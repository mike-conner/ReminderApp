//
//  ViewController.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/24/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class MasterViewController: UITableViewController {
    
    var reminders: [NSManagedObject] = []     // Create an empty array for the storage of reminders after they are fetched from CoreData
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reminderCell")
        
        // Add Navigation (Edit and '+') Controls to MasterVC
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        CoreLocationManager.sharedLocationManager.locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllReminders() // fetch all the reminders everytime the masterVC is reloaded
        tableView.reloadData() // reload table with new or edited reminders
    }
    
    @objc func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "newReminderSegue", sender: self) // perform segue to ReminderDetailVC when the '+' button is pressed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // when performing the segue, check to see if it is for a new reminder or to view the details of an existing reminder (i.e., user tapped a row)
        // if user selected existing reminder, send the reminder to destination 'ReminderDetailVC
        if segue.identifier == "showReminderSegue", let destination = segue.destination as? ReminderDetailViewController, let index = tableView.indexPathForSelectedRow?.row {
            let selectedItem: NSManagedObject = reminders[index] as NSManagedObject
            destination.selectedReminder = selectedItem
        }
    }
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue) {
        // unwind segue for when the user presses 'Save' on ReminderDetailVC
        // once the unwind segue is complete, viewWillAppear will be called and will perform fetchAllReminders and tableView.reloadData()
    }
    
    func fetchAllReminders() {
        // if fetchAllReminders is successful, assign the returned reminders to the collection array 'reminders'
        if let fetchedReminders = CoreDataManager.sharedCoreDataManager.fetchAllReminders() {
            reminders = fetchedReminders
        }
    }
}

// MARK: - Extensions for UITableView delegate methods
extension MasterViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count // the total number of reminders returned from fetchAllReminders
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set up the cells in the tableView from the returned collection of Reminders
        let reminder = reminders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        cell.textLabel?.text = reminder.value(forKey: "reminderDescription") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // needed to be able to edit table view cells
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // needed to be able to delete cells/rows in the table view
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            // stops monitoring for the region once the reminder is deleted from the MasterVC
            for region in CoreLocationManager.sharedLocationManager.locationManager.monitoredRegions {
                if region.identifier == reminders[indexPath.row].value(forKey: "reminderDescription") as? String {
                    CoreLocationManager.sharedLocationManager.locationManager.stopMonitoring(for: region)
                }
            }
            
            CoreDataManager.sharedCoreDataManager.deleteReminder(reminder: reminders[indexPath.row] as! Reminder) // deletes record from CoreData
            reminders.remove(at: indexPath.row) // removes reminder from local collection of reminders
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic) // deletes the row in the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showReminderSegue", sender: self) // calls for 'showReminderSegue' to be performed if a row is selected
    }
}
