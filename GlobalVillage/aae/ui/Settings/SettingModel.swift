import Foundation
import UIKit

class SettingModel: NSObject {
    var name:String!
    var text:String
    var value:AnyObject?
    var identifier: String
    var cellHeight = CGFloat(44)
    init(withJsonName name:String, identifier:String, text:String) {
        self.name = name
        self.text = text
        self.identifier = identifier
    }
    override var description: String {
        return "\(name): \(value)"
    }
}