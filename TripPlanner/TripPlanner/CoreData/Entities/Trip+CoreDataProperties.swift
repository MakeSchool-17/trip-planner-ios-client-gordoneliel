//
//  Trip+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/17/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var tripName: String?
    @NSManaged var wayPoints: NSNumber?
    @NSManaged var id: String?

}
