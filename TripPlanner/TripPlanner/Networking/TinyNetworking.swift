//
//import Foundation
//
//public struct Resource<A> {
//    let path: String
//    let method : Method
//    let requestBody: NSData?
//    let headers : [String:String]
//    let parse: NSData -> A?
//}
//
//public class TinyNetworking {
//    
//    // See the accompanying blog post: http://chris.eidhof.nl/posts/tiny-networking-in-swift.html
//    
//    public enum Method: String { // Bluntly stolen from Alamofire
//        case OPTIONS = "OPTIONS"
//        case GET = "GET"
//        case HEAD = "HEAD"
//        case POST = "POST"
//        case PUT = "PUT"
//        case PATCH = "PATCH"
//        case DELETE = "DELETE"
//        case TRACE = "TRACE"
//        case CONNECT = "CONNECT"
//    }
//    
//    public enum Reason {
//        case CouldNotParseJSON
//        case NoData
//        case NoSuccessStatusCode(statusCode: Int)
//        case Other(NSError)
//    }
//    
//    public func apiRequest<A>(modifyRequest: NSMutableURLRequest -> (), baseURL: NSURL, resource: Resource<A>, failure: (Reason, NSData?) -> (), completion: A -> ()) {
//        let session = NSURLSession.sharedSession()
//        let url = baseURL.URLByAppendingPathComponent(resource.path)
//        let request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = resource.method.rawValue
//        request.HTTPBody = resource.requestBody
//        modifyRequest(request)
//        for (key,value) in resource.headers {
//            request.setValue(value, forHTTPHeaderField: key)
//        }
//        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
//            if let httpResponse = response as? NSHTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                    if let responseData = data {
//                        if let result = resource.parse(responseData) {
//                            completion(result)
//                        } else {
//                            failure(Reason.CouldNotParseJSON, data)
//                        }
//                    } else {
//                        failure(Reason.NoData, data)
//                    }
//                } else {
//                    failure(Reason.NoSuccessStatusCode(statusCode: httpResponse.statusCode), data)
//                }
//            } else {
//                failure(Reason.Other(error!), data)
//            }
//        }
//        task.resume()
//    }
//    
//    // Here are some convenience functions for dealing with JSON APIs
//    
//    public typealias JSONDictionary = [String:AnyObject]
//    
//    func decodeJSON(data: NSData) -> JSONDictionary? {
//        do {
//            return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:AnyObject]
//        }catch _{
//            assert(false)
//        }
//        
//    }
//    
//    func encodeJSON(dict: JSONDictionary) -> NSData? {
//        do {
//            return try dict.count > 0 ? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions()) : nil
//        } catch _{
//            
//        }
//    }
//    
//    public func jsonResource<A>(path: String, method: Method, requestParameters: JSONDictionary, parse: JSONDictionary -> A?) -> Resource<A> {
//        let f = { decodeJSON($0) >>= parse }
//        let jsonBody = encodeJSON(requestParameters)
//        let headers = ["Content-Type": "application/json"]
//        return Resource(path: path, method: method, requestBody: jsonBody, headers: headers, parse: f)
//    }
//    
//}
