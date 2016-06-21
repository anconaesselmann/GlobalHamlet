import Foundation
import UIKit

@objc(ApiController) public class ApiController: NSObject, InitArgsInterface {
    var delegate: APIControllerDelegateProtocol?
    var displayDebugOutput:Bool = true
    var timeout:Double = 2.0
    
//    public func request(urlString:String) {
//        request(urlString, handler: _delegateCaller)
//    }
    
    public func initWithArgs(args:[AnyObject]) {
        displayDebugOutput = args[0] as! Bool
        timeout = args[1] as! Double
    }
    
    public func request(urlString:String, handler:(ApiResponse)->Void) {
        let session = _getSession()
        let request = _getRequestRequest(urlString)
        
        let task = session.dataTaskWithRequest(
            request,
            completionHandler: _getCompletionHandler(handler)
        )
        task.resume()
    }
    //    func postRequest(urlString:String, arguments: Dictionary<String, String>) {
    //        postRequest(urlString, arguments: arguments, handler: _delegateCaller)
    //    }
    //    public func postRequest(urlString:String, arguments: Dictionary<String, String>, handler:(NSDictionary)->Void) {
    //        print(urlString)
    //        let session = _getSession()
    //        let request = _getPostRequest(urlString, arguments: arguments)
    //        let resolvedHandler = _getCompletionHandler(handler)
    //
    //        let task = session.dataTaskWithRequest(
    //            request,
    //            completionHandler: resolvedHandler
    //        )
    //        task.resume()
    //    }
    
    func getUnwrapArray(from url: String, withArrayKey key: String, andCallback callback:([AnyObject])->Void) {
        request(url) { result in
            guard let json = Json.unserialize(result.response)  as? [String: AnyObject] else {
                NSLog("\(result) could not be converted to [String: AnyObject]")
                callback([AnyObject]())
                return
            }
            guard let arrayString = json[key] else {
                NSLog("\(result.response) did not have an \(key) key")
                callback([AnyObject]())
                return
            }
            guard let finalArray = Json.unserialize(arrayString) as? [AnyObject] else {
                NSLog("\(arrayString) could not be converted to [AnyObject]")
                callback([AnyObject]())
                return
            }
            callback(finalArray)
        }
    }
    
    func postRequest(urlString:String, arguments: Dictionary<String, String>, handler:(ApiResponse)->Void) {
        let session = _getSession()
//        let request = _getPostRequest(urlString)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue("application/json", forHTTPHeaderField: "Post-Content-Type")
        request.HTTPMethod = "POST"
        
        let data    = _getData(arguments)
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler: _getCompletionHandler(handler))
//            { (data,response,error) in
//                
//                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
//                    print("error")
//                    return
//                }
//                
//                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                print(dataString)
//        }
        task.resume()
    }
    
    public func imageRequest(urlString:String, handler:(UIImage?)->Void) {
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
    func _requestDecorator(URL URL: NSURL, cachePolicy: NSURLRequestCachePolicy, timeoutInterval: NSTimeInterval) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: URL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request;
    }
    func _getPostRequest(urlString:String) -> NSMutableURLRequest {
        let url         = NSURL(string: urlString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request     = _requestDecorator(
            URL: url!,
            cachePolicy: cachePolicy,
            timeoutInterval: timeout
        )
        request.HTTPMethod = "POST"
        return request
    }
    func _getRequestRequest(urlString:String) -> NSMutableURLRequest {
        let url         = NSURL(string: urlString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request     = _requestDecorator(
            URL: url!,
            cachePolicy: cachePolicy,
            timeoutInterval: timeout
        )
        return request
    }
    func _getImageCompletionHandler(handler:(UIImage?)->Void) -> (NSData?, NSURLResponse?, NSError?) -> Void{
        let h = { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            guard let data = data else {
                handler(nil)
                return
            }
            let url:String? = response?.URL?.absoluteString
            var image:UIImage!;
            if error == nil {
                image = UIImage(data: data)
            }
            else {
                NSLog("Error: \(error!.localizedDescription)")
                image = UIImage(named: "connection")
            }
            self._debugDisplay(url, jsonResult: data, response:response)
            handler(image)
        }
        return h
    }
    
    
    func _getCompletionHandler(handler:(ApiResponse)->Void) -> (NSData?, NSURLResponse?, NSError?) -> Void{
        let h = { (d:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            let apiResponse = ApiResponse()
            guard error == nil else {
                apiResponse.errorCode    = -1
                apiResponse.errorMessage = error!.localizedDescription
                handler(apiResponse)
                return
            }
            guard let data = d else {
                return
            }
            let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            print("Server response as string:")
            print(dataString)
            let statusCode = (response! as? NSHTTPURLResponse)!.statusCode
            guard statusCode < 400 else {
                apiResponse.errorCode    = -2
                apiResponse.errorMessage = "Request failed with connection error \((response! as? NSHTTPURLResponse)!.statusCode)"
                handler(apiResponse)
                return
            }
            print("Status code: \(statusCode)")
            
            let url = response?.URL?.absoluteString
            
            var errorMessage: String?
            var jsonResult: NSDictionary?
            
            do {
                jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            } catch {
                apiResponse.errorCode = -6
                apiResponse.errorMessage = "The server did not return properly formated JSON"
                handler(apiResponse)
                return
            }
            guard jsonResult != nil else {
                apiResponse.errorCode = -3
                apiResponse.errorMessage = "Unknown Error parsing results"
                handler(apiResponse)
                return
            }
            guard let errorCode = jsonResult?["errorCode"] as? Int else {
                apiResponse.errorCode = -4
                apiResponse.errorMessage = "Server did not provide an error code"
                handler(apiResponse)
                return
            }
            if errorCode != 0 {
                apiResponse.errorCode = errorCode
                errorMessage = jsonResult?["errorMessage"] as? String
                if errorMessage == nil {
                    errorMessage = "Server did not provide an error message"
                }
                apiResponse.errorMessage = errorMessage!
                handler(apiResponse)
                return
            }
            guard let jsonResponse = jsonResult?["response"] else {
                apiResponse.errorCode = -5
                apiResponse.errorMessage = "Server did not provide a response"
                handler(apiResponse)
                return
            }
            apiResponse.response = jsonResponse
            self._debugDisplay(url, jsonResult: jsonResult!, response:response)
            handler(apiResponse)
        }
        return h
    }
    func _debugDisplay(url:String?, jsonResult:NSObject, response:NSURLResponse?) {
        if displayDebugOutput {
            if url != nil {
                print("---- response for: " + url! + " ----")
            }
            print(jsonResult)
            print("cookies:")
            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            if response?.URL?.absoluteString != nil {
                print(cookies.cookiesForURL(NSURL(string: response!.URL!.absoluteString)!)!)
            } else {
                print("Error unwrapping cookies")
            }
            print("---- end response ----")
        }
    }
    func _getData(arguments: Dictionary<String, String>) -> NSData? {
        let customAllowedSet =  NSCharacterSet(charactersInString:"!*'();:@&=+$,/?%#[]{|}\"<>\\^`").invertedSet
        var dataString: String = "";
        for (index, element) in arguments {
            if dataString.utf16.count > 0 {
                dataString += "&";
            }
            dataString += index + "=" + element.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!;
        }
        print("post data string:")
        print(dataString);
        return dataString.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
//    func _getMultipartFormDataRequest(
//        urlString:String,
//        arguments: Dictionary<String, String>,
//        fileData: [String: NSData]?,
//        fileNames: [String]?,
//        mimeTypes: [String]?
//        ) -> NSMutableURLRequest {
//            
//            let boundary = generateBoundaryString()
//            let url      = NSURL(string: urlString)
//            let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
//            let request     = _requestDecorator(
//                URL: url!,
//                cachePolicy: cachePolicy,
//                timeoutInterval: timeout
//            )
//            request.HTTPMethod = "POST"
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            request.HTTPBody = createBodyWithParameters(arguments, fileData: fileData, fileNames: fileNames, mimeTypes: mimeTypes, boundary: boundary)
//            return request
//    }
    
    
//    public func multiPartFormDataRequest(
//        urlString:String,
//        arguments: Dictionary<String, String>,
//        fileData: [String: NSData]?,
//        fileNames: [String]?,
//        mimeTypes: [String]?,
//        handler:(ApiResponse)->Void
//        ) {
//        let session     = _getSession()
//        let boundary    = generateBoundaryString()
//        let url         = NSURL(string: urlString)
//        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
//        let request     = _requestDecorator(
//            URL: url!,
//            cachePolicy: cachePolicy,
//            timeoutInterval: timeout
//        )
//        request.HTTPMethod = "POST"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = createBodyWithParameters(arguments, fileData: fileData, fileNames: fileNames, mimeTypes: mimeTypes, boundary: boundary)
//        
//        let resolvedHandler = _getCompletionHandler(handler)
//        
//        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler: _getCompletionHandler(handler))
//        
//        let task1 = session.dataTaskWithRequest(
//            request,
//            completionHandler: resolvedHandler
//        )
//        task.resume()
//    }
    
    func _getData1(arguments: Dictionary<String, String>) -> NSData? {
        let customAllowedSet =  NSCharacterSet(charactersInString:"!*'();:@&=+$,/?%#[]{|}\"<>\\^`").invertedSet
        var dataString: String = "";
        for (index, element) in arguments {
            if dataString.utf16.count > 0 {
                dataString += "&";
            }
            dataString += index + "=" + element.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!;
        }
        print("post data string:")
        print(dataString);
        return dataString.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    func postRequest1(urlString:String, arguments: Dictionary<String, String>, handler:(ApiResponse)->Void) {
        let session = _getSession()
        //        let request = _getPostRequest(urlString)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue("application/json", forHTTPHeaderField: "Post-Content-Type")
        request.HTTPMethod = "POST"
        
        let data    = _getData(arguments)
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler: _getCompletionHandler(handler))
        //            { (data,response,error) in
        //
        //                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
        //                    print("error")
        //                    return
        //                }
        //
        //                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //                print(dataString)
        //        }
        task.resume()
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
                    
                    i += 1
                }
            }
            
            body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSISOLatin1StringEncoding)!)
            return body
    }
    
    
    
    func multiPartFormDataRequest(
        urlString:String,
        arguments: [String: String],
        fileData: [String: NSData]?,
        fileNames: [String]?,
        mimeTypes: [String]?,
        handler:(ApiResponse)->Void
        ) {
        
        let myUrl = NSURL(string: urlString);
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Post-Content-Type")
        
        
        let imageData = fileData!["fileToUpload"]!
        
        request.HTTPBody = createBodyWithParameters(arguments, filePathKey: "fileToUpload", imageDataKey: imageData, boundary: boundary)
        
        //        myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                NSLog("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    print(parseJSON)
                }
            } catch {
                
            }
            dispatch_async(dispatch_get_main_queue(),{
                //                self.myActivityIndicator.stopAnimating()
                print("Hello")
                //                self.myImageView.image = nil;
            });
        }
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}