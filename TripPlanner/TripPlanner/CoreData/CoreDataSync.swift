//
//  CoreDataSync.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/28/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import CoreData

typealias SynchronizerCallback = [Trip] -> Void

class CoreDataSync {
    
    var managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func sync(callback: SynchronizerCallback) {
        let coreDataClient = CoreDataClient(managedObjectContext: self.managedObjectContext)
        
        APIClient.sharedInstance.getTrips("eliel", password: "gordon") {
            trips in
            
            let coreDataTripIds = coreDataClient.allTrips().map { $0.tripId!}
            let newServerTrips = trips?.filter {
                !coreDataTripIds.contains($0.tripId!)
            }

            newServerTrips?.forEach {
                let trip = Trip(context: self.managedObjectContext, jsonTrip: $0)
                
                $0.waypoints?.forEach {
                    let waypoint = Waypoint(context: self.managedObjectContext, jsonWaypoint: $0)
                    waypoint.trip = trip
                }
            }
            
            do {
                try self.managedObjectContext.save()
            } catch let error {
                print(error)
            }
            try! self.managedObjectContext.save()
            
            let trips = coreDataClient.allTrips()
            callback(trips)
            
        }
    }
}