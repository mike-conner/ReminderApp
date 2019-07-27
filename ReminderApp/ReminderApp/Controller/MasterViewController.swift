//
//  ViewController.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/24/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var stubData = StubData()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reminderCell")
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "newReminderSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReminderSegue", let destination = segue.destination as? ReminderDetailViewController, let index = tableView.indexPathForSelectedRow?.row {
            destination.reminderDetailsTextFieldText = stubData.names[index]
        }
    }

}
