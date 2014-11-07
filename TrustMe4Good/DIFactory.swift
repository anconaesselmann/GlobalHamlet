import Foundation

public class DIFactory: DICProtocol {
    var _dict: Dictionary<String, AnyObject>!
    var _factory: SimpleFactory!
    
    init (fileName:String) {
        _loadConfig(fileName)
    }
    
    func _loadConfig(fileName:String) {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist") {
            _dict = NSDictionary(contentsOfFile: path) as Dictionary<String, AnyObject>
        }
        assert(_dict != nil)
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
        return []
    }
    public func build(idString: String) -> AnyObject! {
        if let className = getClassName(idString) as String? {
            var args:[AnyObject] = getConstArgs(idString)
            if args.count > 0 {
                for (index, arg) in enumerate(args) {
                    if let dict = arg as? [String:String] {
                        if let dep = dict["dep"] {
                            args[index] = build(dep)
                        } else if let const = dict["const"] {
                            args[index] = get(const)
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
    public func decorate(obj:InitArgsInterface, idString: String) {
        var args:[AnyObject] = getConstArgs(idString)
        if args.count > 0 {
            for (index, arg) in enumerate(args) {
                if let dict = arg as? [String:String] {
                    if let dep = dict["dep"] {
                        args[index] = build(dep)
                    } else if let const = dict["const"] {
                        args[index] = get(const)
                    }
                }
            }
            _factory.decorate(obj, args: args)
        }
    }
    public func decorate(obj:InitArgsInterface) {
        let name = _stdlib_getDemangledTypeName(obj)
        let components = name.componentsSeparatedByString(".")
        decorate(obj, idString: components.last!)
    }
    public func get(idString: String) -> AnyObject! {
        if _dict != nil {
            if let varVal: AnyObject = _dict[idString] {
                return varVal
            }
        }
        return nil
    }
}