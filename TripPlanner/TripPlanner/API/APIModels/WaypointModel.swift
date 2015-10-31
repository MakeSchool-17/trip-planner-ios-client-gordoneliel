//
//  WaypointModel.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/30/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import Gloss

struct WaypointModel: Glossy {
    let latitude: Double?
    let longitude: Double?
    let name: String?
    
    init?(json: JSON) {
        self.latitude = "latitude" <~~ json
        self.longitude = "longitude" <~~ json
        self.name = "name" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "latitude" ~~> latitude,
            "longitude" ~~> longitude,
            "name" ~~> name
            ])
    }
}