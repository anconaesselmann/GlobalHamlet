import Foundation

class Json {
    class func unserialize(serialized: AnyObject?) -> AnyObject? {
        guard let data = serialized?.dataUsingEncoding(NSUTF8StringEncoding) else {
            print("Error unserializing")
            return nil
        }
        var json: AnyObject?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as AnyObject
        } catch {
            print("Error unserializing \(serialized!): \(error)")
        }
        return json
    }
}