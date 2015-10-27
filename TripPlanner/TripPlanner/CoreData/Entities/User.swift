//
//  User.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/17/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
}
