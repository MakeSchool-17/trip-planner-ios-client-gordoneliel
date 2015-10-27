//
//  UserModel.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/22/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import Gloss

struct UserModel: Glossy {
    var username: String
    var id: String
    
    
    init(username: String, id: String) {
        self.username = username
        self.id = id
    }
    
    init?(json: JSON) {
        self.username = ("username" <~~ json)!
        self.id = ("_id" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "username" ~~> username,
            "_id" ~~> id
        ])
    }
}