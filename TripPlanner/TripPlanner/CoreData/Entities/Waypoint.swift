//
//  Waypoint.swift
//  
//
//  Created by Eliel Gordon on 10/30/15.
//
//

import Foundation
import CoreData


class Waypoint: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Waypoint", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
    convenience init(context: NSManagedObjectContext, jsonWaypoint: WaypointModel) {
        let entityDescription = NSEntityDescription.entityForName("Waypoint", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
        
        name = jsonWaypoint.name
        latitude = jsonWaypoint.latitude
        longitude = jsonWaypoint.longitude
    }
}
