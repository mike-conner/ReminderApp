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
    
    @IBOutlet weak var label: UILabel!
    
    var labelText = String()
    
    override func viewWillAppear(_ animated: Bool) {
        label.text = labelText
    }
    
}

