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
        
        APIClient.sharedInstance.getTrips {
            trips in
            
            let coreDataTripIds = coreDataClient.allTrips().map { $0.tripId!}
            let coreDataTrips = coreDataClient.allTrips()
            
//            var newServerTrips: [TripModel]?
            
//            for serverTrip in trips!{
//                if coreDataTrips.count != 0{
//                    for coreDataTrip in coreDataTrips {
//                        if coreDataTrip.updatedAt?.doubleValue <= serverTrip.updatedAt{
//                            newServerTrips?.append(serverTrip)
//                        }
//                    }
//                } else {
//                    newServerTrips = trips
//                }
//            }
            
            let newServerTrips = trips?.filter {
                !coreDataTripIds.contains($0.tripId!)
//                coreDataTrips.contains($0.tripId!)
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
            
            let trips = coreDataClient.allTrips()
            callback(trips)
            
        }
    }
}