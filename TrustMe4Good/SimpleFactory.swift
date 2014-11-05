import Foundation

@objc public protocol InitArgsInterface {
    func initWithArgs(args:NSArray)
}

public class SimpleFactory {
    public func build(className: String) -> AnyObject! {
        if let aClass = NSClassFromString(className) as? NSObject.Type {
            return aClass()
        }
        return nil
    }
    public func buildWithArgs(className: String, args: NSArray) -> AnyObject! {
        if let aClass = NSClassFromString(className) as? NSObject.Type {
            if var instance = aClass() as? InitArgsInterface {
                instance.initWithArgs(args)
                return instance
            }
        }
        return nil
    }
}