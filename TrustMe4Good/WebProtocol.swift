import Foundation

@objc protocol WebProtocol {
    func postRequst(urlString: String, arguments: Dictionary<String, String>?) -> NSDictionary
    func postRequst(urlString: String) -> NSDictionary
    func getResponseWithError(url:String, error:Error) -> AnyObject?
    func getResponseWithError(url:String, arguments: Dictionary<String, String>, error:Error) -> AnyObject?
}