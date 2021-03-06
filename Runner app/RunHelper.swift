//
//  RunHelper.swift
//  Runner app
//
//  Created by Jonathan Holm on 17/02/15.
//  Copyright (c) 2015 iOSGroup3. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Class for functions connected to Run.
class RunHelper {
    
    // Enum for the status of a run. This way it is consistent everywhere and cleaner
    // then just relying on hardcoded integers.
    enum Status: Int {
        case Scheduled = 0, Started, Completed, Running
    }
    
    // Enum for the repeating status of a run.
    enum RepeatingStatus: Int {
        case None = 0, Daily, Weekly, Monthly
    }
    
    // Creates a new run to make an existing run seem to repeat. This function is only called
    // when the user has specified that the run will repeat and when that run is completed.
    class func CreateRescheduling(completedRun: Run) {
        
        // Create schedule run if the incoming run has RepeatingStatus != None.
        if completedRun.repeatingStatus == RepeatingStatus.None.rawValue {
            return
        }
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context = delegate.managedObjectContext
        var newRun = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: context!) as Run
        
        newRun.name = completedRun.name
        newRun.status = Status.Scheduled.rawValue
        newRun.repeatingStatus = completedRun.repeatingStatus
        
        var components = NSDateComponents()
        if completedRun.repeatingStatus == RepeatingStatus.Daily.rawValue {
            components.day = 1
        } else if completedRun.repeatingStatus == RepeatingStatus.Weekly.rawValue {
            components.day = 7
        } else { // Monthly
            components.month = 1
        }
        
        newRun.startDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: completedRun.startDate, options: NSCalendarOptions(0))!
        
        var error: NSError?
        if !context!.save(&error) {
            println("Could not save \(error)")
        }
    }
    
    // Fetches all completed runs from core data.
    class func GetCompletedRuns() -> [Run] {
        
        var runs = [Run]()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Run")
        var error: NSError?
        
        // Filter the fetch by only taking those with status == completed
        fetchRequest.predicate = NSPredicate(format: "status = %i" , RunHelper.Status.Completed.rawValue )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        let fetchedResult = managedContext.executeFetchRequest(fetchRequest, error: &error) as [Run]?
        
        if let results = fetchedResult{
            runs = results
        }
        return runs
    }
    
    
    //returns the runs between two dates
    //Alexander Lagerqvist
    class func GetCompletedRunsBetweenDates(firstDate: NSDate, secondDate: NSDate) -> [Run] {
        
        var runs = [Run]()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Run")
        var error: NSError?
        
        let firstConditionPredicate = NSPredicate(format: "startDate >= %@", firstDate)
        let secondConditionPredicate = NSPredicate(format: "startDate <= %@", secondDate)
        let thirdConditionPredicate = NSPredicate(format: "status = %i" , RunHelper.Status.Completed.rawValue )
        
        fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType , subpredicates: [firstConditionPredicate!,secondConditionPredicate!,thirdConditionPredicate!])
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        let fetchedResult = managedContext.executeFetchRequest(fetchRequest, error: &error) as [Run]?
        
        if let results = fetchedResult{
            runs = results
        }
        return runs
    }
}