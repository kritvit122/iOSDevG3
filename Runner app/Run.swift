//
//  Run.swift
//  Runner app
//
//  Created by Jonathan Holm on 13/02/15.
//  Copyright (c) 2015 iOSGroup3. All rights reserved.
//

import Foundation
import CoreData

class Run: NSManagedObject {

    @NSManaged var averageSpeed: NSNumber
    @NSManaged var distance: NSNumber
    @NSManaged var fromLocation: NSNumber
    @NSManaged var name: String
    @NSManaged var route: NSData
    @NSManaged var startDate: NSDate
    @NSManaged var status: NSNumber
    @NSManaged var repeatingStatus: NSNumber
    @NSManaged var stopDate: NSDate
    @NSManaged var lastResumeDate: NSDate
    @NSManaged var toLocation: NSNumber
    @NSManaged var savedTime: NSNumber
    @NSManaged var weather: String?
    @NSManaged var locations: NSSet
    @NSManaged var pace: String
    @NSManaged var pauseLocations: NSSet

}
