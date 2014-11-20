import UIKit

class Mock_Segue: UIStoryboardSegue {}

/*class Web_Mock: WebProtocol {
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
}*/
class Mock_DiViewController: DICViewController {}
class Mock_Settings: SettingsProtocol {
    var switches:[String: Bool] = Dictionary<String, Bool>()
    var s:Bool = false
    var string:String = ""
    var json:String = ""
    func setSwitches(dict: [String: Bool]) {}
    func getSwitches() -> [String: Bool] {return switches}
    func setSwitch(key: String, value: Bool) {}
    func getSwitch(key: String) -> Bool {return s}
    func setString(key: String, value: String) {}
    func getString(key: String) -> String {return string}
    func getJson() -> String {return json}
    func linkSwitches(namedSwitches: [NamedSwitch]) {}
    func updateNamedSwitch(name: String) {}
}