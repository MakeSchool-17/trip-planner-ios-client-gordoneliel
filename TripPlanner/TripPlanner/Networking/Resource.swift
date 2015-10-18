//
//  Resource.swift
//  TripPlanner
//
//  Created by Eliel Gordon on 10/17/15.
//  Copyright © 2015 Saltar Group. All rights reserved.
//

import Foundation

struct Resource<A> {
    let path: String
    let method : HTTPMethod
    let requestBody: NSData?
    let headers : [String:String]
    let parse: NSData -> A?
}

enum HTTPMethod: String { // Bluntly stolen from Alamofire
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}
