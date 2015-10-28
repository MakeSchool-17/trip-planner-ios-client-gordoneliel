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
    var tripName: String
    var tripUser: String
    var createdAt: String
    var id: String
    
    init(tripName: String, tripUser: String) {
        self.tripName = tripName
        self.tripUser = tripUser
        self.id = ""
        self.createdAt = ""
    }
    
    init?(json: JSON) {
        self.id = ("_id" <~~ json)!
        self.tripUser = ("username" <~~ json)!
        self.tripName = ("tripName" <~~ json)!
        
        let date: String = ("createdAt" <~~ json)!
        
        self.createdAt = date
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "tripName" ~~> tripName,
            "username" ~~> tripUser,
        ])
    }
}
