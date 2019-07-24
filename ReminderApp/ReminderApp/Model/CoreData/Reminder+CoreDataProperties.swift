//
//  Reminder+CoreDataProperties.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/24/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var reminderDescription: String?
    @NSManaged public var reminderLocation: String?
    @NSManaged public var reminderLatitude: Double
    @NSManaged public var reminderLongitude: Double
    @NSManaged public var isEntering: Bool

}
