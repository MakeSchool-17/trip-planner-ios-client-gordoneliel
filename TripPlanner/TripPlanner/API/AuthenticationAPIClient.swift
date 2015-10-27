//
//  AuthenticationAPIClient.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import Gloss

typealias LoginCompletionHandler = User? -> Void

struct BasicAuth {
    static func generateBasicAuthHeader(username: String, password: String) -> String {
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        let authHeaderString = "Basic \(base64LoginString)"
        return authHeaderString
    }
}

class AuthenticationAPIClient: NSObject {
    
    // Singleton
    static let sharedInstance = AuthenticationAPIClient()
    
    
    enum AuthenticationRouter {
        static let loginUrlString = "http://192.168.1.206:5000/users/"
        static let logoutUrlString = "https://127.0.0.1/Logout"
        static let signUpUrlString = "http://127.0.0.1/users/"
        static let UsernameRESTKey = "username"
        static let PasswordRESTKey = "password"
        
        
        case Login, Signup, Signout
    }
    
    func parseUser(data: NSData) -> User? {
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0)) as! JSON
        
        let user = UserModel(json: jsonData)
        
        let coreDataUser = CoreDataParser.parseUserToCoreData(user!)
        
        return coreDataUser
    }
    
    func authenticatedUser(username: String, password: String, method: HTTPMethod) -> Resource<User> {
        let basicAuth = BasicAuth.generateBasicAuthHeader(username, password: password)
        return Resource(path: "", method: method, requestBody: nil,
            headers: ["Authorization": basicAuth], parse: parseUser)
    }
    
    func signUpUser(username: String, password: String, method: HTTPMethod) -> Resource<User> {
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(["username":username, "password": password], options: NSJSONWritingOptions.init(rawValue: 0))
        
        return Resource(path: "", method: method, requestBody: jsonData, headers: [:], parse:parseUser)
    }
    
    func defaultFailureHandler(failureReason: TinyNetworking.Reason, data: NSData?) {
        let string = String(data: data!, encoding: NSUTF8StringEncoding)
        print("Failure: \(failureReason) \(string)")
    }
    
    // MARK: - Authentication of User from Server
    /**
    :abstract: Makes an *asynchronous* request to login a user with specified credentials.
    
    :discussion: Returns an instance of the successfully logged.
    
    - parameter username: The username of the user.
    - parameter password: The password of the user.
    
    - returns: Returns an instance of the `User` on success.
    If login failed for either wrong password or wrong username, returns `Failure`.
    */
    func loginWithUsernameInBackground(username username: String, password: String, loginCallback: LoginCompletionHandler) {
        
        let resource = authenticatedUser(username, password: password, method: .GET)
        let failure = defaultFailureHandler
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: NSURL(string:AuthenticationRouter.loginUrlString)!, resource: resource, failure: failure) {
                message in
                
                loginCallback(message)
            }
        }
    }
    
    /**
     :abstract: Makes an *asynchronous* request to logout a user with specified credentials.
     
     :discussion: This will also trigger a remove from the Realm database
     */
    func logoutInBackground() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            
            
        }
    }
    
    /**
     Signs a *User* into our service
     
     - parameter username:       The username
     - parameter password:       The password
     - parameter signUpCallback: Completion handler for signing up. Propagates response of a sign up
     */
    func signUpInBackground(username username: String, password: String, signUpCallback: LoginCompletionHandler) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            TinyNetworking.sharedInstance.apiRequest({_ in }, baseURL: NSURL(string: AuthenticationRouter.loginUrlString)!, resource: self.signUpUser(username, password: password, method: .POST), failure: self.defaultFailureHandler) {
                
                message in
                print(message)
                
            }
        }
    }
}