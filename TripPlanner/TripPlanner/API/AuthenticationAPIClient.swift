////
////  AuthenticationAPIClient.swift
////  TripPlanner
////
////  Created by Eliel Gordon on 10/14/15.
////  Copyright © 2015 Saltar Group. All rights reserved.
////
//
//import Foundation
//
//typealias LoginCompletionHandler = () -> Void
//
//class AuthenticationAPIClient: NSObject {
//    
//    // Singleton
//    static let sharedInstance = AuthenticationAPIClient()
//    
//    enum AuthenticationRouter {
//        static let loginUrlString = "https://127.0.0.1/Login"
//        static let logoutUrlString = "https://127.0.0.1/Logout"
//        static let UsernameRESTKey = "username"
//        static let PasswordRESTKey = "password"
//        
//
//        case Login, Signup, Signout
//    }
//    
//    func parseString(data: NSData) -> String? {
//        return String(data: data, encoding: NSUTF8StringEncoding)
//    }
//    
//    func zen() -> Resource<String> {
//        return Resource(path: "zen", method: Method.GET,
//            requestBody: nil, headers: [:], parse: parseString)
//    }
//    
//    func defaultFailureHandler(failureReason: Reason, data: NSData?) {
//        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
//        print("Failure: \(failureReason) \(string)")
//    }
//    
//    // MARK: - Authentication of User from Server
//    /**
//    :abstract: Makes an *asynchronous* request to login a user with specified credentials.
//    
//    :discussion: Returns an instance of the successfully logged.
//    
//    - parameter username: The username of the user.
//    - parameter password: The password of the user.
//    
//    - returns: Returns an instance of the `User` on success.
//    If login failed for either wrong password or wrong username, returns `Failure`.
//    */
//    func loginWithUsernameInBackground(username username: String, password: String, loginCallback: LoginCompletionHandler) {
//        
//        let params = [AuthenticationRouter.UsernameRESTKey:username, AuthenticationRouter.PasswordRESTKey: password]
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
//            
//            apiRequest({ _ in }, baseURL: NSURL(string: AuthenticationRouter.loginUrlString)!, resource: self.zen(), failure: self.defaultFailureHandler)
//                { message in
//                    
//            }
//        }
//    }
//    
//    /**
//    :abstract: Makes an *asynchronous* request to logout a user with specified credentials.
//    
//    :discussion: This will also trigger a remove from the Realm database
//    */
//    func logoutInBackground() {
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
//            
//            
//        }
//    }
//    
//    func signUpInBackground() {
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
//            
//            
//        }
//    }
//}