//
//  ApiClient.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/20/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import Gloss
import KeychainAccess

typealias TripCallback = ([TripModel]?) -> Void
typealias GooglePlaceCallback = (Results?) -> Void

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
    private func parseTrip(data: NSData) -> [TripModel]? {
        
        let tripData = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0)) as! [JSON]
        
        var tripModels: [TripModel] = []
        tripModels = TripModel.modelsFromJSONArray(tripData)!
        
        return tripModels
    }
    
    private func parseTripForPost(data: NSData) -> String? {
        return  String(data: data, encoding: NSUTF8StringEncoding)!
    }
    
    private func defaultFailureHandler(failureReason: TinyNetworking.Reason, data: NSData?) {
        guard let data = data else {return}
        let string = String(data: data, encoding: NSUTF8StringEncoding)
        print("Failure: \(failureReason) \(string)")
    }
    
    /**
     Handles a post request for a trip
     
     - parameter trip:   The trip to be posted
     - parameter user:   The user associated with the trip post
     - parameter method: The type of network request
     
     - returns: Sucess or Error
     */
    private func tripPost(trip: TripModel, method: HTTPMethod) -> Resource<String> {
        
        let (username, password) = AuthenticationController.sharedInstance.fetchUserDetails()!
        
        let auth = BasicAuth.generateBasicAuthHeader(username, password: password)
        
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
    func tripGet(username: String, password: String, method: HTTPMethod) -> Resource<[TripModel]> {
        
        let auth = BasicAuth.generateBasicAuthHeader(username, password: password)
        
        return Resource(path: "", method: method, requestBody: nil, headers: ["Authorization": auth], parse:parseTrip)
    }
    
    func tripPut(trip: TripModel, method: HTTPMethod) -> Resource<String> {
        
        let (username, password) = AuthenticationController.sharedInstance.fetchUserDetails()!
        
        let auth = BasicAuth.generateBasicAuthHeader(username, password: password)
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(trip.toJSON()!, options: NSJSONWritingOptions.init(rawValue: 0))
        
        return Resource(path: "\(trip.tripId!)", method: method, requestBody: jsonData, headers: ["Authorization": auth], parse: parseTripForPost)
    }
    /**
     Posts a trip to the server
     
     - parameter trip:       The trip to be posted
     - parameter user:       The user the trip is associated with
     */
    func postTrip(trip:TripModel) {
        
        let resource = tripPost(trip, method: .POST)
        let url = NSURL(string: Router.tripEndpoint)!
        
        TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: url, resource: resource, failure: self.defaultFailureHandler) {
            message in
        }
        
    }
    
    /**
     Fetches a user's trips
     
     - parameter username: The username of the user
     - parameter password: The password of the user
     - parameter callback: Completion handler for the result of the network request from fetching the trips
     */
    func getTrips(callback: TripCallback) {
        
        let (username, password) = AuthenticationController.sharedInstance.fetchUserDetails()!
        
        let resource = tripGet(username, password: password, method: .GET)
        let url = NSURL(string: Router.tripEndpoint)!
        
        TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: url, resource: resource, failure: self.defaultFailureHandler) {
            trips in
            
            callback(trips)
        }
    }
    
    /**
     Updates a trip on the server
     
     - parameter trip:       The trip to be posted
     - parameter user:       The user the trip is associated with
     */
    func putTrip(trip:TripModel) {
        
        let resource = tripPut(trip, method: .PUT)
        let url = NSURL(string: Router.tripEndpoint)!
        
        TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: url, resource: resource, failure: self.defaultFailureHandler) {
            message in
        }
    }
    
    // Mark: Google Places Api
    
    private func parsePlaces(data: NSData) -> [Results]? {
        
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0)) as! JSON
        let results = jsonData["results"] as! [JSON]
        let waypointModel = Results.modelsFromJSONArray(results)
        return waypointModel
    }
    
    private func getGooglePlace(text: String, method: HTTPMethod) -> Resource<[Results]> {
        
        return Resource(path: "/maps/api/place/textsearch/json", method: method, requestBody: nil, headers: [:], parse: parsePlaces)
    }
    
    func fetchLikelyPlace(text: String , callback: GooglePlaceCallback) {
        
        let resource =  getGooglePlace(text, method: .GET)
        let urlString = "https://maps.googleapis.com/?query=\(text)&key=AIzaSyCduSwsqeJaFGK156DSfMOKrt5TLFPg-rU"
        let url = NSURL(string: urlString)!
        
        TinyNetworking.sharedInstance.apiRequest({_ in}, baseURL: url, resource: resource, failure: self.defaultFailureHandler) {
            place in
        }
    }
}