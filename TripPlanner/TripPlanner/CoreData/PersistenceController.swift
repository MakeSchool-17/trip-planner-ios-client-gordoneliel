//
//  PersistenceController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/20/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import CoreData

typealias PersistanceCallback = () -> Void

class PersistenceController: NSObject {
    
    var managedObjectContext: NSManagedObjectContext?
    var privateContext: NSManagedObjectContext?
    
    var callback: PersistanceCallback?
    
    convenience init(callback: PersistanceCallback) {
        self.init()
        self.callback = callback
        initializeCoreData()
    }
    
    func initializeCoreData() {
        if (self.managedObjectContext != nil) {return}
        
        let modelURL = NSBundle.mainBundle().URLForResource("TripPlanner", withExtension: "momd")!
        NSManagedObjectModel(contentsOfURL: modelURL)!
    }
    
    func save() {

    }
}