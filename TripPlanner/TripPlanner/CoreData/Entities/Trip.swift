//
//  Trip.swift
//
//
//  Created by Eliel Gordon on 10/28/15.
//
//

import Foundation
import CoreData


class Trip: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Trip", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
    convenience init(context: NSManagedObjectContext, jsonTrip: TripModel) {
        let entityDescription = NSEntityDescription.entityForName("Trip", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
        
        tripName = jsonTrip.tripName
        tripId = jsonTrip.tripId
        user = jsonTrip.tripUser
        updatedAt = jsonTrip.updatedAt
    }
}
