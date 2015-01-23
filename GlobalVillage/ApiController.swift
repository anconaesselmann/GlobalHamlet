import Foundation
import UIKit

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
    func multiPartFormDataRequest(
        urlString:String,
        arguments: Dictionary<String, String>,
        fileData: [String: NSData]?,
        fileNames: [String]?,
        mimeTypes: [String]?,
        handler:(NSDictionary)->Void
    ) {
        let session = _getSession()
        let request = _getMultipartFormDataRequest(
            urlString,
            arguments: arguments,
            fileData: fileData,
            fileNames: fileNames,
            mimeTypes: mimeTypes
        )
        
        let resolvedHandler = _getCompletionHandler(handler)
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: resolvedHandler
        )
        task.resume()
    }
    
    func imageRequest(urlString:String, handler:(UIImage)->Void) {
        let session = _getSession()
        let request = _getRequestRequest(urlString)
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: _getImageCompletionHandler(handler)
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
    func _getImageCompletionHandler(handler:(UIImage)->Void) -> (NSData?, NSURLResponse?, NSError?) -> Void{
        var h = { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            let url:String? = response?.URL?.absoluteString?
            var image:UIImage!;
            if error == nil {
                image = UIImage(data: data!)
            }
            else {
                println("Error: \(error!.localizedDescription)")
                image = UIImage(named: "connection")
            }
            self._debugDisplay(url, jsonResult: data!, response:response)
            handler(image)
        }
        return h
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
    func _debugDisplay(url:String?, jsonResult:NSObject, response:NSURLResponse?) {
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
    
    func _getMultipartFormDataRequest(
        urlString:String,
        arguments: Dictionary<String, String>,
        fileData: [String: NSData]?,
        fileNames: [String]?,
        mimeTypes: [String]?
    ) -> NSMutableURLRequest {
        
        let boundary = generateBoundaryString()
        let url      = NSURL(string: urlString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request     = NSMutableURLRequest(
            URL: url!,
            cachePolicy: cachePolicy,
            timeoutInterval: timeout
        )
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = createBodyWithParameters(arguments, fileData: fileData, fileNames: fileNames, mimeTypes: mimeTypes, boundary: boundary)
        return request
    }
    
    func createBodyWithParameters(
        arguments: [String: String]?,
        fileData: [String: NSData]?,
        fileNames: [String]?,
        mimeTypes: [String]?,
        boundary: String
    ) -> NSData {
        
        let body = NSMutableData()
        
        let boundaryData   = "--\(boundary)\r\n".dataUsingEncoding(NSISOLatin1StringEncoding)!
        
        if arguments != nil {
            for (key, value) in arguments! {
                body.appendData(boundaryData)
                body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSISOLatin1StringEncoding)!)
                body.appendData("\(value)\r\n".dataUsingEncoding(NSISOLatin1StringEncoding)!)
            }
        }
        
        if fileData != nil {
            var i = 0
            for (argumentName, data) in fileData! {
                let filename = fileNames![i]
                let mimetype = mimeTypes![i]
                
                let cdString = "Content-Disposition: form-data; name=\"\(argumentName)\"; filename=\"\(filename)\"\r\n"
                
                body.appendData(boundaryData)
                body.appendData(cdString.dataUsingEncoding(NSISOLatin1StringEncoding)!)
                body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSISOLatin1StringEncoding)!)
                body.appendData(data)
                body.appendData("\r\n".dataUsingEncoding(NSISOLatin1StringEncoding)!)
                
                i++
            }
        }
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSISOLatin1StringEncoding)!)
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
}