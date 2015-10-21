//
//  ApiClient.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/20/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation

class APIClient: NSObject {
    // Singleton
    static let sharedInstance = APIClient()
    
    /// Path per resource
    enum Router {
        static let tripEndpoint = "http://172.30.2.150:5000/mytrips/"
        static let UsernameRESTKey = "username"
        static let PasswordRESTKey = "password"
    }

    func parseString(data: NSData) -> String? {
        return String(data: data, encoding: NSUTF8StringEncoding)
    }
    
    func defaultFailureHandler(failureReason: TinyNetworking.Reason, data: NSData?) {
        //                let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //                print("Failure: \(failureReason) \(string)")
    }
    
    func tripResource(tripName: String, timeOfTrip: NSDate, user: String, method: HTTPMethod) -> Resource<String> {
        let json = ["tripName": tripName, "timeOfTrip": timeOfTrip, "user": user]
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.init(rawValue: 0))
        return Resource(path: "", method: method, requestBody: jsonData, headers: [:], parse: parseString)

    }
    
    func tripGet(username: String, password: String, method: HTTPMethod) -> Resource<String> {
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(["username":username, "password": password], options: NSJSONWritingOptions.init(rawValue: 0))
        
        return Resource(path: "", method: method, requestBody: jsonData, headers: ["username": username, "password": password], parse:parseString)
    }
    
    /**
    Posts a trip to the server
    
    - parameter tripName:   The name of the trip to be added
    - parameter timeOfTrip: The time the trip will occcur
    - parameter user:       The user the trip is associated with
    */
    func postTrip(tripName: String, timeOfTrip: NSDate, user: String) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: NSURL(string: Router.tripEndpoint)!, resource: self.tripResource(tripName, timeOfTrip: timeOfTrip, user: user, method: .POST), failure: self.defaultFailureHandler) {
                message in
            }
        }
    }
    
    func getTrips(user: User) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: NSURL(string: Router.tripEndpoint)!, resource: self.tripGet(user.username!, password: "", method: .GET), failure: self.defaultFailureHandler) {
                message in
                
            }
        }
    }
}