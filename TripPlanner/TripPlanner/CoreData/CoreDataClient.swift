//
//  CoreDataClient.swift
//  NetworkingCoreData
//
//  Created by Benjamin Encz on 10/30/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataClient {
  
  var managedObjectContext: NSManagedObjectContext
  
  init(managedObjectContext: NSManagedObjectContext) {
    self.managedObjectContext = managedObjectContext
  }
  
  func allTrips() -> [Trip] {
    let fetchRequest = NSFetchRequest(entityName: "Trip")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tripId", ascending: false)]
    let trips = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Trip]
    
    return trips
  }
  
}