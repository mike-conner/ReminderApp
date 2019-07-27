//
//  Reminder+CoreDataProperties.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/26/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var isEntering: Bool
    @NSManaged public var reminderDescription: String?
    @NSManaged public var reminderLatitude: Double
    @NSManaged public var reminderLocation: String?
    @NSManaged public var reminderLongitude: Double

}
