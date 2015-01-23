import Foundation

@objc public protocol InitArgsInterface {
    func initWithArgs(args:[AnyObject])
}

public class SimpleFactory {
    public func build(className: String) -> AnyObject! {
        if let aClass = NSClassFromString(className) as? NSObject.Type {
            return aClass()
        }
        return nil
    }
    public func buildWithArgs(className: String, args: [AnyObject]) -> AnyObject! {
        if let aClass = NSClassFromString(className) as? NSObject.Type {
            if var instance = aClass() as? InitArgsInterface {
                instance.initWithArgs(args)
                return instance
            }
        }
        return nil
    }
    public func decorate(obj: InitArgsInterface, args:[AnyObject]) {
        obj.initWithArgs(args)
    }
}