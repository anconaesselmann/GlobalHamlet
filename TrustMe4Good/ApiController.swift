import Foundation

@objc(ApiController) class ApiController: NSObject {
    var delegate: APIControllerDelegateProtocol?

    func request(urlString:String) {
        let session = _getSession()
        let request = _getRequestRequest(urlString)
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: _completionHandler
        )
        task.resume()
    }
    
    func postRequest(urlString:String, arguments: Dictionary<String, String>) {
        let session = _getSession()
        let request = _getPostRequest(urlString, arguments: arguments)
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: _completionHandler
        )
        task.resume()
    }
    
    func _getSession() -> NSURLSession {
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        //delegate!.cookies = cookies
        let configObject = NSURLSessionConfiguration.defaultSessionConfiguration()
        configObject.HTTPCookieStorage = cookies
        configObject.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
        let session      = NSURLSession(
            configuration: configObject,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        return session
    }
    func _getRequestRequest(urlString:String) -> NSMutableURLRequest {
        let url         = NSURL(string: urlString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request     = NSMutableURLRequest(
            URL: url!,
            cachePolicy: cachePolicy,
            timeoutInterval: 2.0
        )
        return request
    }

    func _completionHandler(data:NSData?, response:NSURLResponse?, error:NSError?) {
        let url:String? = response?.URL?.absoluteString?
        if url != nil {
            println("---- response for: " + url! + " ----")
        }
        if(error != nil) {
            NSLog(error!.localizedDescription)
            self.delegate?.didReceiveAPIResults(["response": false, "errorCode": -1])
            return
        }
        var err: NSError?
        
        var jsonResult:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
        if(err != nil) {
            NSLog("JSON parsing Error \(err!.localizedDescription)")
            self.delegate?.didReceiveAPIResults(["response": false, "errorCode": -2])
            return
        }
        //let results: NSArray = jsonResult["response"] as NSArray
        //let errorCode: Int   = jsonResult["errorCode"] as Int
        println(jsonResult!)
        println("cookies:")
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        println(cookies.cookiesForURL(NSURL(string: response!.URL!.absoluteString!)!)!)
        println("---- end response ----")
        if delegate == nil {
            NSLog("ERROR: Delegate is nil.")
        }
        self.delegate?.didReceiveAPIResults(jsonResult!)
    }
    
    func _getPostRequest(urlString:String, arguments: Dictionary<String, String>) -> NSMutableURLRequest {
        let url         = NSURL(string: urlString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request     = NSMutableURLRequest(
            URL: url!,
            cachePolicy: cachePolicy,
            timeoutInterval: 2.0
        )
        request.HTTPMethod = "POST"
        
        // set data
        var dataString: String = "";
        for (index, element) in arguments {
            if dataString.utf16Count > 0 {
                dataString += "&";
            }
            dataString += index + "=" + element.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        }
        println("post data string:")
        println(dataString);
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody    = requestBodyData
        
        return request
    }
    
}