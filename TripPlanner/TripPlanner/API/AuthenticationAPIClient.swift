//
//  AuthenticationAPIClient.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/14/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation

typealias LoginCompletionHandler = String -> Void

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
        static let loginUrlString = "http://172.30.2.150:5000/myusers/"
        static let logoutUrlString = "https://127.0.0.1/Logout"
        static let signUpUrlString = "http://127.0.0.1/myusers/"
        static let testUrl = "http://requestb.in/vns4ahvn"
        static let UsernameRESTKey = "username"
        static let PasswordRESTKey = "password"
        
        
        case Login, Signup, Signout
    }
    
    func parseString(data: NSData) -> String? {
        return String(data: data, encoding: NSUTF8StringEncoding)
    }
        
    func authenticatedUser(username: String, password: String, method: HTTPMethod) -> Resource<String> {
        let basicAuth = BasicAuth.generateBasicAuthHeader(username, password: password)
        return Resource(path: "", method: method, requestBody: nil,
            headers: ["Authorization": basicAuth], parse: parseString)
    }
    
    func defaultFailureHandler(failureReason: TinyNetworking.Reason, data: NSData?) {
//                let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //        print("Failure: \(failureReason) \(string)")
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
        
        let params = [AuthenticationRouter.UsernameRESTKey:username, AuthenticationRouter.PasswordRESTKey: password]
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            
            TinyNetworking.sharedInstance.apiRequest({ _ in }, baseURL: NSURL(string:AuthenticationRouter.loginUrlString)!, resource: self.authenticatedUser(username, password: password, method: .GET), failure: self.defaultFailureHandler)
                { message in
                    
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
    
    func signUpInBackground(username username: String, password: String, signUpCallback: LoginCompletionHandler) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            TinyNetworking.sharedInstance.apiRequest({_ in }, baseURL: NSURL(string: AuthenticationRouter.signUpUrlString)!, resource: self.authenticatedUser(username, password: password, method:.POST), failure: self.defaultFailureHandler) {
                 message in
            }
        }
    }
}