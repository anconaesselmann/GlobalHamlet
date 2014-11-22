import Foundation

@objc(ApiController) class ApiController: NSObject, InitArgsInterface {
    var delegate: APIControllerDelegateProtocol?
    var displayDebugOutput:Bool = true
    var timeout:Double = 2.0

    func request(urlString:String) {
        request(urlString, handler: _delegateCaller)
    }
    func postRequest(urlString:String, arguments: Dictionary<String, String>) {
        postRequest(urlString, arguments: arguments, handler: _delegateCaller)
    }
    
    func initWithArgs(args:[AnyObject]) {
        displayDebugOutput = args[0] as Bool
        timeout = args[1] as Double
    }
    
    func request(urlString:String, handler:(NSDictionary)->Void) {
        let session = _getSession()
        let request = _getRequestRequest(urlString)
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: _getCompletionHandler(handler)
        )
        task.resume()
    }
    func postRequest(urlString:String, arguments: Dictionary<String, String>, handler:(NSDictionary)->Void) {
        let session = _getSession()
        let request = _getPostRequest(urlString, arguments: arguments)
        
        let resolvedHandler = _getCompletionHandler(handler)
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: resolvedHandler
        )
        task.resume()
    }
    
    func _delegateCaller(dict:NSDictionary) {
        if delegate == nil {
            NSLog("ERROR: Delegate is nil.")
        }
        delegate?.didReceiveAPIResults(dict)
    }
    
    
    func _getSession() -> NSURLSession {
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
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
            timeoutInterval: timeout
        )
        return request
    }
    func _getCompletionHandler(handler:(NSDictionary)->Void) -> (NSData?, NSURLResponse?, NSError?) -> Void{
        var h = { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            var jsonResult:NSDictionary?
            let url:String? = response?.URL?.absoluteString?
            if(error != nil) {
                NSLog(error!.localizedDescription)
                jsonResult = NSDictionary(dictionary: ["response": false, "errorCode": -1])
            }
            if response != nil && (response! as? NSHTTPURLResponse)!.statusCode >= 400 {
                NSLog("Request failed with connection error \((response! as? NSHTTPURLResponse)!.statusCode)")
                jsonResult = NSDictionary(dictionary: ["response": false, "errorCode": -2])
            }
            var err: NSError?
            if jsonResult == nil {
                jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
                if(err != nil) {
                    NSLog("JSON parsing Error \(err!.localizedDescription)")
                    jsonResult = NSDictionary(dictionary: ["response": false, "errorCode": -3])
                }
                if jsonResult == nil {
                    NSLog("Unknown Error parsing results")
                    jsonResult = NSDictionary(dictionary: ["response": false, "errorCode": -4])
                }
            }
            if jsonResult?["response"]? == nil || jsonResult?["errorCode"]? == nil {
                NSLog("nor response or error code.")
                println(jsonResult)
                jsonResult = NSDictionary(dictionary: ["response": false, "errorCode": -5])
            }
            self._debugDisplay(url, jsonResult: jsonResult!, response:response)
            handler(jsonResult!)
        }
        return h
    }
    func _debugDisplay(url:String?, jsonResult:NSDictionary, response:NSURLResponse?) {
        if displayDebugOutput {
            if url != nil {
                println("---- response for: " + url! + " ----")
            }
            println(jsonResult)
            println("cookies:")
            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            println(cookies.cookiesForURL(NSURL(string: response!.URL!.absoluteString!)!)!)
            println("---- end response ----")
        }
    }

    
    func _getPostRequest(urlString:String, arguments: Dictionary<String, String>) -> NSMutableURLRequest {
        let url         = NSURL(string: urlString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request     = NSMutableURLRequest(
            URL: url!,
            cachePolicy: cachePolicy,
            timeoutInterval: timeout
        )
        request.HTTPMethod = "POST"
        
        var customAllowedSet =  NSCharacterSet(charactersInString:"!*'();:@&=+$,/?%#[]{|}\"<>\\^`").invertedSet

        // set data
        var dataString: String = "";
        for (index, element) in arguments {
            if dataString.utf16Count > 0 {
                dataString += "&";
            }
            dataString += index + "=" + element.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!;
        }
        println("post data string:")
        println(dataString);
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody    = requestBodyData
        
        return request
    }
    
}