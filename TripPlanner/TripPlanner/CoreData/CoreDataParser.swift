//
//  CoreDataParser.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/26/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import CoreData

/// Parses Networking Model Objects into Core Data Entities
final class CoreDataParser {
    
    /**
     Converts a TripModel to a Core Data Trip Entity
     
     - parameter jsonModel: The TripModel from the JSON
     
     - returns: A Core Data trip entity
     */
    class func parseTripToCoreData(jsonModel: TripModel) -> Trip {
        
        let context = CoreDataStack().managedObjectContext
        
        let coreDataTripEntity = Trip(context: context)
        coreDataTripEntity.tripName = jsonModel.tripName
        coreDataTripEntity.tripName = jsonModel.id
        
        return coreDataTripEntity
    }
    
    class func parseUserToCoreData(jsonModel: UserModel) -> User {
        let context = CoreDataStack().managedObjectContext
        
        let coreDataUserEntity = User(context: context)
        
        coreDataUserEntity.username = jsonModel.username
        coreDataUserEntity.userId = jsonModel.userId
        
//        CoreDataStack().saveContext()
        
        return coreDataUserEntity
    }
}