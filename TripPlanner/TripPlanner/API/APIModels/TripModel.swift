//
//  Trip.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/22/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import Gloss

struct TripModel: Glossy {
    var tripName: String?
    var tripUser: String?
    var createdAt: String?
    var tripId: String?
    var waypoints: [WaypointModel]?
    
    init(tripName: String) {
        self.tripName = tripName
        self.tripUser = ""
        self.tripId = ""
        self.createdAt = ""
        self.waypoints = []
    }
    
    init?(json: JSON) {
        self.tripId = "_id" <~~ json
        self.tripUser = "username" <~~ json
        self.tripName = "tripName" <~~ json
        
        let date: String = ("createdAt" <~~ json)!
        
        self.createdAt = date
        self.waypoints = "waypoints" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "tripName" ~~> tripName,
            "username" ~~> tripUser,
            "waypoints" ~~> waypoints
        ])
    }
}
