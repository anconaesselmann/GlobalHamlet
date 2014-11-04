import Foundation

public class SimpleFactory {
    public func build(className: String) -> NSObject! {
        if let aClass = NSClassFromString(className) as? NSObject.Type {
            return aClass()
        }
        return nil
    }
}