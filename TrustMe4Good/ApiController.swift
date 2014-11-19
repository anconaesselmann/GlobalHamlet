import Foundation

@objc(ApiController) class ApiController: NSObject {
    var delegate: AppDelegate?
    

    func getSession() -> NSURLSession {
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        delegate!.cookies = cookies
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
    func getRequest(urlString:String) -> NSMutableURLRequest {
        let url         = NSURL(string: urlString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request     = NSMutableURLRequest(
            URL: url!,
            cachePolicy: cachePolicy,
            timeoutInterval: 2.0
        )
        return request
    }

    func completionHandler(data:NSData?, response:NSURLResponse?, error:NSError?) {
        println("---- response for: " + response!.URL!.absoluteString! + " ----")
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
        println("---- end response ----")
        self.delegate?.didReceiveAPIResults(jsonResult!)
    }
    func request(urlString:String) {
        let session = getSession()
        let request = getRequest(urlString)

        let task = session.dataTaskWithRequest(
            request,
            completionHandler: completionHandler
        )
        task.resume()
    }
    
    func postRequest(url:String, searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                //let results: NSArray = jsonResult["results"] as NSArray
                self.delegate?.didReceiveAPIResults(jsonResult)
            })
            
            task.resume()
        }
    }
    
    /* -(void) httpPostWithCustomDelegate
    {
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://hayageek.com/examples/jquery/ajax-post/ajax-post.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * params =@"name=Ravi&loc=India&age=31&submit=true";
    [urlRequest setHTTPMethod:@"POST"];
    
    
    
    
    
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSLog(@"Response:%@ %@\n", response, error);
    if(error == nil)
    {
    NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog(@"Data = %@",text);
    }
    
    }];
    [dataTask resume];
    
    }*/
    
}