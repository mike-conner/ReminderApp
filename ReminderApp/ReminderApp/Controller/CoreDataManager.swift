//
//  CoreDataManager.swift
//  ReminderApp
//
//  Created by Mike Conner on 7/26/19.
//  Copyright © 2019 Mike Conner. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ReminderApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Add a new reminder
    func insertNewReminder (reminderDescription: String, reminderLocation: String, isEntering: Bool, reminderLatitude: Double, reminderLongitude: Double) -> Reminder? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedContext)!
        let reminder = NSManagedObject(entity: entity, insertInto: managedContext)
        
        reminder.setValue(reminderDescription, forKey: "reminderDescription")
        reminder.setValue(reminderLocation, forKey: "reminderLocation")
        reminder.setValue(isEntering, forKey: "isEntering")
        reminder.setValue(reminderLatitude, forKey: "reminderLatitude")
        reminder.setValue(reminderLongitude, forKey: "reminderLongitude")
        
        do {
            try managedContext.save()
            return reminder as? Reminder
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
//    // Add a new reminder - testing function only!
//    func insertNewReminder (reminderDescription: String, isEntering: Bool) -> Reminder? {
//        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedContext)!
//        let reminder = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        reminder.setValue(reminderDescription, forKey: "reminderDescription")
//        reminder.setValue("No Location Entered", forKey: "reminderLocation")
//        reminder.setValue(isEntering, forKey: "isEntering")
//        reminder.setValue(0.0, forKey: "reminderLatitude")
//        reminder.setValue(0.0, forKey: "reminderLongitude")
//
//        do {
//            try managedContext.save()
//            return reminder as? Reminder
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//            return nil
//        }
//    }
    
    // Update a reminder
    func updateReminder (reminderDescription: String, reminderLocation: String, isEntering: Bool, reminderLatitude: Double, reminderLongitude: Double, reminder: Reminder) {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        reminder.setValue(reminderDescription, forKey: "reminderDescription")
        reminder.setValue(reminderLocation, forKey: "reminderLocation")
        reminder.setValue(isEntering, forKey: "isEntering")
        reminder.setValue(reminderLatitude, forKey: "reminderLatitude")
        reminder.setValue(reminderLongitude, forKey: "reminderLongitude")
        
        do {
            try context.save()
            print("updated")
        } catch let error as NSError {
            print("Could not update \(error), \(error.userInfo)")
        }
    }
    
    // Delete a reminder
    func deleteReminder (reminder: Reminder) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        managedContext.delete(reminder)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Fetch all reminders stored in CoreData
    func fetchAllReminders() -> [Reminder]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        
        do {
            let reminder = try managedContext.fetch(fetchRequest)
            return reminder as? [Reminder]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}






















































