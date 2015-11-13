//
//  AuthenticationAPIClient.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import Gloss

typealias LoginCallback = UserModel? -> Void

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
        static let loginUrlString = "http://172.30.2.150:5000/users/"
        static let logoutUrlString = "https://127.0.0.1/Logout"
        static let signUpUrlString = "http://127.0.0.1/users/"
        
        case Login, Signup, Signout
    }
    
    private func parseUser(data: NSData) -> UserModel? {
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0)) as! JSON
        
        let user = UserModel(json: jsonData)!
        
        return user
    }
    
    private func authenticatedUser(username: String, password: String, method: HTTPMethod) -> Resource<UserModel> {
        let basicAuth = BasicAuth.generateBasicAuthHeader(username, password: password)
        return Resource(path: "", method: method, requestBody: nil,
            headers: ["Authorization": basicAuth], parse: parseUser)
    }
    
    private func signUpUser(username: String, password: String, method: HTTPMethod) -> Resource<UserModel> {
        
        let user = UserModel(username: username, password: password).toJSON()!
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(user, options: NSJSONWritingOptions.init(rawValue: 0))
        
        return Resource(path: "", method: method, requestBody: jsonData, headers: [:], parse:parseUser)
    }
    
    private func defaultFailureHandler(failureReason: TinyNetworking.Reason, data: NSData?) {
        print("Failure: \(failureReason)")
    }
    
    // MARK: - Authentication of User from Server
    /**
    :abstract: Makes an *asynchronous* request to login a user with specified credentials.
    
    :discussion: Returns an instance of the successfully logged.
    After successful login, stores the user's credentials in the keychain with Authentication Controller
    
    - parameter username: The username of the user.
    - parameter password: The password of the user.
    
    - returns: Returns an instance of the `User` on success.
    If login failed for either wrong password or wrong username, returns `Failure`.
    */
    func loginWithUsernameInBackground(username username: String, password: String, loginCallback: LoginCallback) {
        let resource = authenticatedUser(username, password: password, method: .GET)
        let failure = defaultFailureHandler
        
        TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: NSURL(string:AuthenticationRouter.loginUrlString)!, resource: resource, failure: failure) {
            user in
            
            AuthenticationController.sharedInstance.saveUserDetails(username: username, password: password)
            loginCallback(user)
        }
    }
    
    /**
     :abstract: Makes an *asynchronous* request to logout a user with specified credentials.
     
     :discussion: This will also trigger a remove from the Realm database
     */
    func logoutInBackground() {
        
    }
    
    /**
     Signs a *User* into our service
     
     - parameter username:       The username
     - parameter password:       The password
     - parameter signUpCallback: Completion handler for signing up. Propagates response of a sign up
     */
    func signUpInBackground(username username: String, password: String, signUpCallback: LoginCallback) {
        
        TinyNetworking.sharedInstance.apiRequest({_ in }, baseURL: NSURL(string: AuthenticationRouter.loginUrlString)!, resource: self.signUpUser(username, password: password, method: .POST), failure: self.defaultFailureHandler) {
            user in
            
            AuthenticationController.sharedInstance.saveUserDetails(username: username, password: password)
            signUpCallback(user)
            
        }
    }
}