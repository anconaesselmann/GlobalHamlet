import UIKit

class Mock_Segue: UIStoryboardSegue {}

class Web_Mock: WebProtocol {
    var urlCalled: String = ""
    var urlCallResult: [String: AnyObject] = Dictionary<String, AnyObject>()
    var argsPassed: [String: String] = Dictionary<String, String>()
    
    func postRequst(
        urlString: String,
        arguments: Dictionary<String, String>?
        ) -> NSDictionary {
            urlCalled = urlString
            return urlCallResult
    }
    func postRequst(urlString: String) -> NSDictionary {
        urlCalled = urlString
        return urlCallResult
    }
    func getResponseWithError(url:String, error:Error) -> AnyObject? {
        urlCalled = url
        return urlCallResult
    }
    func getResponseWithError(url:String, arguments: Dictionary<String, String>, error:Error) -> AnyObject? {
        urlCalled = url
        argsPassed = arguments
        return urlCallResult
    }
}
class Mock_DiViewController: DICViewController {}