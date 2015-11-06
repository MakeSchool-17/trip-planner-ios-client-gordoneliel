//
//  GooglePlaceModel.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 11/5/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import Gloss

struct Results: Decodable {
    var geometry: Geometry?
    var formattedAddress: String?
    
    init?(json: JSON) {
        self.geometry = "geometry" <~~ json
        self.formattedAddress = "formatted_address" <~~ json
    }
}

struct Geometry: Decodable {
    var location: Location?
    
    init?(json: JSON) {
        self.location = "location" <~~ json
    }
}

struct Location: Decodable {
    var latitude: Double?
    var longitude: Double?
    
    init?(json: JSON) {
        self.latitude = "lat" <~~ json
        self.longitude = "lng" <~~ json
    }
}