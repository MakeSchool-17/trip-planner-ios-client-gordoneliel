//
//  AuthenticationController.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/29/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation
import KeychainAccess

class AuthenticationController {
    
    //Singleton
    static let sharedInstance = AuthenticationController()
    private let service = "com.saltar.TripPlanner"
    
    /**
     Saves the details of a user in the keychain
     
     - parameter user: The user model to extract data from
     */
    func saveUserDetails(username username: String, password: String) {
        let keychain = Keychain(service: service)
        do{
            try keychain.set(username, key: "username")
            try keychain.set(password, key: "password")
        } catch {
            
        }
    }
    
    /**
     Fetches the details of a user from the keychain
     
     - returns: The credentials of a user
     */
    func fetchUserDetails() -> (String, String)? {
        let keychain = Keychain(service: service)
        do {
            return try (keychain.get("username")!, keychain.get("password")!)
        } catch {
            
        }
        return nil
    }
}