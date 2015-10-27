//
//  ApiClient.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/20/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import Gloss

typealias TripCallback = [Trip]? -> Void

class APIClient: NSObject {
    // Singleton
    static let sharedInstance = APIClient()
    
    /// Path per resource
    enum Router {
        static let tripEndpoint = "http://172.30.2.150:5000/trips/"
        static let UsernameRESTKey = "username"
        static let PasswordRESTKey = "password"
    }
    
    /**
     Parses an NSData from the network to a Trip entitiy
     
     - parameter data: The NSData from the server
     
     - returns: A Trip entity
     */
    func parseTrip(data: NSData) -> [Trip]? {
        
        let tripData = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0)) as! [JSON]
        
        var tripModel = [TripModel]()
        var tripEntities = [Trip]()
        

        for json in tripData {
            tripModel.append(TripModel(json: json)!)
        }
        
        for trip in tripModel {
            tripEntities.append(CoreDataParser.parseTripToCoreData(trip))
        }
        
        return tripEntities
    }
    
    func defaultFailureHandler(failureReason: TinyNetworking.Reason, data: NSData?) {
        let string = String(data: data!, encoding: NSUTF8StringEncoding)
        print("Failure: \(failureReason) \(string)")
    }
    
    func tripPost(tripName: String, timeOfTrip: NSDate, user: UserModel, method: HTTPMethod) -> Resource<[Trip]> {
        let auth = BasicAuth.generateBasicAuthHeader(user.username, password: "gordon")
        
        let tripPost = TripModel(tripName: tripName, tripUser: user.username).toJSON()!
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(tripPost, options: NSJSONWritingOptions.init(rawValue: 0))
        
        return Resource(path: "", method: method, requestBody: jsonData, headers: ["Authorization": auth], parse: parseTrip)
    }
    
    /**
     Fetches the trips from the backend server
     
     - parameter username: The user fetching the trips
     - parameter password: The password of the user
     - parameter method:   The type of HTTP Request
     
     - returns: A Trip
     */
    func tripGet(username: String, password: String, method: HTTPMethod) -> Resource<[Trip]> {
        
        let auth = BasicAuth.generateBasicAuthHeader(username, password: password)
        
        return Resource(path: "", method: method, requestBody: nil, headers: ["Authorization": auth], parse:parseTrip)
    }
    
    /**
     Posts a trip to the server
     
     - parameter tripName:   The name of the trip to be added
     - parameter timeOfTrip: The time the trip will occcur
     - parameter user:       The user the trip is associated with
     */
    func postTrip(tripName: String, timeOfTrip: NSDate, user: UserModel, callback: TripCallback) {
        
        let resource = tripPost(tripName, timeOfTrip: timeOfTrip, user: user, method: .POST)
        let url = NSURL(string: Router.tripEndpoint)!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: url, resource: resource, failure: self.defaultFailureHandler) {
                trip in
                
                callback(trip)
            }
        }
    }
    
    func getTrips(username: String, password: String, callback: TripCallback) {
        
        let resource = tripGet(username, password: password, method: .GET)
        let url = NSURL(string: Router.tripEndpoint)!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: url, resource: resource, failure: self.defaultFailureHandler) {
                trips in
                
                callback(trips)
            }
        }
    }
}