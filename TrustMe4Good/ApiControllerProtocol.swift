import Foundation

@objc protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}