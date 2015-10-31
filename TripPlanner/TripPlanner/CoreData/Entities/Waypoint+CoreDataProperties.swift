//
//  Waypoint+CoreDataProperties.swift
//  
//
//  Created by Eliel Gordon on 10/30/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Waypoint {

    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var trip: Trip?

}
