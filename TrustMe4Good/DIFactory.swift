import Foundation

public class DIFactory {
    var _dict: NSDictionary!
    var _factory: SimpleFactory!
    
    init () {
        _loadConfig()
    }
    
    func _loadConfig() {
        if let path = NSBundle.mainBundle().pathForResource("configTest", ofType: "plist") {
            _dict = NSDictionary(contentsOfFile: path)
        }
        _factory = SimpleFactory()
    }
    
    func getClassName(idString: String) -> String! {
        if _dict != nil {
            if let def = _dict.objectForKey(idString) as? NSDictionary {
                if let result = def.objectForKey("class") as? String {
                    return result
                }
            }
        }
        return nil
    }
    func getConstArgs(idString: String) -> NSArray! {
        if _dict != nil {
            if let def = _dict.objectForKey(idString) as? NSDictionary {
                if let result = def.objectForKey("args") as? NSArray {
                    return result
                }
            }
        }
        return nil
    }
    
    
    public func build(idString: String) -> AnyObject! {
        if let className = getClassName(idString) as String? {
            let args = getConstArgs(idString)
            if args.count > 0 {
                return _factory.buildWithArgs(className, args:args)
            } else {
                return _factory.build(className)
            }
        }
        return nil
    }
}