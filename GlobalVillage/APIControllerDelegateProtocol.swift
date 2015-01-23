import Foundation

@objc protocol APIControllerDelegateProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}