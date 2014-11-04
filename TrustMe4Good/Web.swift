import Foundation
import UIKit

class Web {
    var uuid = UIDevice().identifierForVendor.UUIDString;
    
    func postRequst(urlString: String, arguments: Dictionary<String, String>?) -> NSDictionary {
        let url            = NSURL(string: urlString);
        let cachePolicy    = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request        = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        
        // set Content-Type in HTTP header
        let boundaryConstant = "----------V2ymHFg03esomerandomstuffhbqgZCaKO6jy";
        let contentType      = "multipart/form-data; boundary=" + boundaryConstant
        NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
        
        // set data
        var dataString: String = "";
        for (index, element) in arguments! {
            if dataString.utf16Count > 0 {
                dataString += "&";
            }
            dataString += index + "=" + element;
        }
        println(dataString);
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody    = requestBodyData
        
        // set content length
        NSURLProtocol.setProperty(requestBodyData!.length, forKey: "Content-Length", inRequest: request)
        
        var response: NSURLResponse? = nil
        var error:    NSError?       = nil
        let reply                    = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
        
        //let results = NSString(data:reply!, encoding:NSUTF8StringEncoding);
        
        let jsonData: NSData = reply!;
        
        let json:AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error);
        if json is NSDictionary {
            return json as NSDictionary;
        }
        return ["response": false, "errorCode": -1];
        
        //out.text = dict["response"] as NSString;
        //return true;
    }
    /*func postRequst(urlString: String) -> NSDictionary {
    let url            = NSURL(string: urlString);
    let cachePolicy    = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
    var request        = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 2.0)
    request.HTTPMethod = "POST"
    
    // set Content-Type in HTTP header
    let boundaryConstant = "----------V2ymHFg03esomerandomstuffhbqgZCaKO6jy";
    let contentType      = "multipart/form-data; boundary=" + boundaryConstant
    NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
    
    // set data
    var dataString: String = "";
    
    println(dataString);
    let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    request.HTTPBody    = requestBodyData
    
    // set content length
    NSURLProtocol.setProperty(requestBodyData!.length, forKey: "Content-Length", inRequest: request)
    
    var response: NSURLResponse? = nil
    var error:    NSError?       = nil
    let reply                    = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
    
    //let results = NSString(data:reply!, encoding:NSUTF8StringEncoding);
    
    let jsonData: NSData = reply!;
    
    let json:AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error);
    if json is NSDictionary {
    return json as NSDictionary;
    }
    return ["response": false, "errorCode": -1];
    }*/
    
}