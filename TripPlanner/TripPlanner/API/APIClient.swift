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
        static let tripEndpoint = "http://192.168.1.206:5000/trips/"
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
    
    func parseTripForPost(data: NSData) -> String? {
        return  String(data: data, encoding: NSUTF8StringEncoding)!
    }
    
    func defaultFailureHandler(failureReason: TinyNetworking.Reason, data: NSData?) {
        let string = String(data: data!, encoding: NSUTF8StringEncoding)
        print("Failure: \(failureReason) \(string)")
    }
    
    /**
     Handles a post request for a trip
     
     - parameter trip:   The trip to be posted
     - parameter user:   The user associated with the trip post
     - parameter method: The type of network request
     
     - returns: Sucess or Error
     */
    func tripPost(trip: TripModel, user: UserModel, method: HTTPMethod) -> Resource<String> {
        let auth = BasicAuth.generateBasicAuthHeader(user.username, password: "gordon")
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(trip.toJSON()!, options: NSJSONWritingOptions.init(rawValue: 0))
        
        return Resource(path: "", method: method, requestBody: jsonData, headers: ["Authorization": auth], parse: parseTripForPost)
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
     
     - parameter trip:       The trip to be posted
     - parameter user:       The user the trip is associated with
     */
    func postTrip(trip:TripModel, user: UserModel) {
        
        let resource = tripPost(trip, user: user, method: .POST)
        let url = NSURL(string: Router.tripEndpoint)!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: url, resource: resource, failure: self.defaultFailureHandler) {
                message in
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