//
//  ViewController.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/24/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    let stubData = StubData()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reminderCell")
        
        navigationItem.leftBarButtonItem = editButtonItem
        
/*      Code to add a new functionality to add a new button goes here. Need to set up story board first and then write insertNewObject function...
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton */
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stubData.names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        cell.textLabel?.text = stubData.names[indexPath.row]
        return cell
    }

}

