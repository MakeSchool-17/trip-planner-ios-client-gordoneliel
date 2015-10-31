
import Foundation

typealias JSONDictionary = [String:AnyObject]

public class TinyNetworking {
    
    // See the accompanying blog post: http://chris.eidhof.nl/posts/tiny-networking-in-swift.html
    static let sharedInstance = TinyNetworking()
    
    public enum Reason {
        case CouldNotParseJSON
        case NoData
        case NoSuccessStatusCode(statusCode: Int)
        case Other(NSError)
    }
    
    func apiRequest<A>(modifyRequest: NSMutableURLRequest -> (), baseURL: NSURL, resource: Resource<A>, failure: (Reason, NSData?) -> (), completion: A -> ()) {
        let session = NSURLSession.sharedSession()
        let url = baseURL
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = resource.method.rawValue
        request.HTTPBody = resource.requestBody
        modifyRequest(request)
        for (key,value) in resource.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            guard let httpResponse = response as? NSHTTPURLResponse, responseData = data else { return failure(Reason.NoData, data) }
            
            if httpResponse.statusCode == 200 {
                dispatch_async(dispatch_get_main_queue()){
                    guard let result = resource.parse(responseData) else {return}
                    completion(result)
                }
            }else{
                failure(Reason.NoSuccessStatusCode(statusCode: httpResponse.statusCode), data)
            }
//            
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
        }
        task.resume()
    }
    

    
    func decodeJSON(data: NSData) -> JSONDictionary? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:AnyObject]
        }catch _{
            assert(false)
        }
        
    }
    
    func encodeJSON(dict: JSONDictionary) -> NSData? {
        do {
            return try dict.count > 0 ? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions()) : NSData()
        } catch _{
           assert(false)
        }
    }
    
//    func jsonResource<A>(path: String, method: Method, requestParameters: JSONDictionary, parse: JSONDictionary -> A?) -> Resource<A> {
//        let f = { decodeJSON($0) >>= parse }
//        let jsonBody = encodeJSON(requestParameters)
//        let headers = ["Content-Type": "application/json"]
//        return Resource(path: path, method: method, requestBody: jsonBody, headers: headers, parse: f)
//    }
    
}


// Here are some convenience functions for dealing with JSON APIs


