import Foundation

extension NSBundle {
    class func mainInfoDictionary(key: CFString) -> String {
        return self.mainBundle().infoDictionary?[key as String] as! String
    }
}