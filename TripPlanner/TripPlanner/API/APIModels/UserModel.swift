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
    var password: String
    var userId: String
    
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.userId = ""
    }
    
    init?(json: JSON) {
        self.username = ("username" <~~ json)!
        self.userId = ("_id" <~~ json)!
        self.password = ("password" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "username" ~~> username,
            "_id" ~~> userId,
            "password" ~~> password
        ])
    }
}