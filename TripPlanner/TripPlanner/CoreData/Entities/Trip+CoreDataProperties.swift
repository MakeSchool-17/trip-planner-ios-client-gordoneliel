//
//  Trip+CoreDataProperties.swift
//  
//
//  Created by Eliel Gordon on 10/28/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var tripId: String?
    @NSManaged var tripName: String?
    @NSManaged var user: String?
    @NSManaged var updatedAt: NSNumber?
    @NSManaged var createdAt: NSNumber?
    @NSManaged var waypoints: NSSet?
}
