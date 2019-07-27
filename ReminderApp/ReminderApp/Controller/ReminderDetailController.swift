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
    
    var reminderDetailsTextFieldText: String?                                   // code for testing
    
    @IBOutlet weak var reminderDetailsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reminderDetailsTextField.text = reminderDetailsTextFieldText            // code for testing
    }
    
}

