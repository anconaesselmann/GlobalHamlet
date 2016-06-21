import Foundation

@objc public protocol APIControllerDelegateProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}