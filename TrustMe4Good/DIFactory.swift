import Foundation

public class DIFactory {
    var _dict: Dictionary<String, AnyObject>!
    var _factory: SimpleFactory!
    
    init () {
        _loadConfig()
    }
    
    func _loadConfig() {
        if let path = NSBundle.mainBundle().pathForResource("configTest", ofType: "plist") {
            _dict = NSDictionary(contentsOfFile: path) as Dictionary<String, AnyObject>
        }
        _factory = SimpleFactory()
    }
    
    func getClassName(idString: String) -> String! {
        if _dict != nil {
            if let def = _dict[idString] as? Dictionary<String, AnyObject> {
                if let result = def["class"] as? String {
                    return result
                }
            }
        }
        return nil
    }
    func getConstArgs(idString: String) -> [AnyObject]! {
        if _dict != nil {
            if let def = _dict[idString] as? [String: AnyObject] {
                if let result = def["args"] as? [AnyObject] {
                    return result
                }
            }
        }
        return nil
    }
    public func build(idString: String) -> AnyObject! {
        if let className = getClassName(idString) as String? {
            var args:[AnyObject] = getConstArgs(idString)
            if args.count > 0 {
                for (index, arg) in enumerate(args) {
                    if let dict = arg as? [String:String] {
                        if let dep = dict["dep"] {
                            args[index] = build(dep)
                        }
                    }
                }
                return _factory.buildWithArgs(className, args:args)
            } else {
                return _factory.build(className)
            }
        }
        return nil
    }
}