//
//  ViewController.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/24/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {
    
    var reminders: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reminderCell")
        
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllReminders()
    }
    
    @objc func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "newReminderSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReminderSegue", let destination = segue.destination as? ReminderDetailViewController, let index = tableView.indexPathForSelectedRow?.row {
            let selectedItem: NSManagedObject = reminders[index] as NSManagedObject
            destination.selectedReminder = selectedItem
        }
        
    }
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        fetchAllReminders()
        tableView.reloadData()
    }
    
    func fetchAllReminders() {
        if let fetchedReminders = CoreDataManager.sharedManager.fetchAllReminders() {
            reminders = fetchedReminders
        }
    }

}

// MARK: - Extensions

extension MasterViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminder = reminders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        cell.textLabel?.text = reminder.value(forKey: "reminderDescription") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            CoreDataManager.sharedManager.deleteReminder(reminder: reminders[indexPath.row] as! Reminder)
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showReminderSegue", sender: self)
    }
}
