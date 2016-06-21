//
//  JsonObjectMapper.swift
//  socipelago
//
//  Created by Axel Ancona Esselmann on 3/12/16.
//  Copyright © 2016 Axel Ancona Esselmann. All rights reserved.
//

import Foundation
import UIKit

enum PropertyTypes:String {
    case OptionalInt = "Optional<Int>"// does not work currently. http://stackoverflow.com/questions/26118811/using-setvaluevalue-forkey-key-on-int-types-fires-non-key-value-coding-comp
    case OptionalNSNumber = "Optional<NSNumber>"
    case Int = "Int"
    case OptionalDouble = "OptionalDouble<Double>"
    case Double = "Double"
    case OptionalString = "Optional<String>"
    case String = "String"
    
    case Bool = "Bool"
    case OptionalBool = "Optional<Bool>"
    
    case OptionalUIImage = "Optional<UIImage>"
    
    case OptionalNSDate = "Optional<NSDate>"
}
extension Mirror {
    func getTypeOf(property name:String, ofObject obj:AnyObject)->String? {
        let type: Mirror = Mirror(reflecting:obj)
        
        for child in type.children {
            if child.label! == name {
                return String(child.value.dynamicType)
            }
        }
        return nil
    }
    func property(propertyName:String, of obj: AnyObject, isOfType type:PropertyTypes)->Bool {
        if getTypeOf(property: propertyName, ofObject: obj) == type.rawValue {
            return true
        }
        return false
    }
}

public class JsonObjectMapper {
    
    class public func map(json json:[String:AnyObject?], toObjectInstance object: AnyObject) -> AnyObject? {
        let mirror = Mirror(reflecting: object)
        
        print("\n\nBegin\n")
        for child in mirror.children {
            guard let key = child.label else {
                continue
            }
            guard let type = mirror.getTypeOf(property: key, ofObject: object) else {
                print("Could not get type of \(key)")
                continue
            }
            switch type {
            // Optionals, don't fail if not set
            case PropertyTypes.OptionalString.rawValue:
                print("\(key) is of type \(type)")
                guard let value = json[key] as? String else {
                    continue
                }
                object.setValue(value, forKey: key)
                print("\(key) set to \(value)")
            
            case PropertyTypes.OptionalInt.rawValue:
                NSLog("ERROR: \(key) is of type \(type). Currently Swift creates errors when using optional ints")
            case PropertyTypes.OptionalBool.rawValue:
                 NSLog("ERROR: \(key) is of type \(type). Currently Swift creates errors when using optional bools")
                
            case PropertyTypes.OptionalNSNumber.rawValue:
                print("\(key) is of type \(type)")
                var value = json[key] as? Int
                if value == nil {
                    guard let stringValue = json[key] as? String else {
                        print("could not convert \(json[key]) to string")
                        continue
                    }
                    value = Int(stringValue)
                }
                guard value != nil else {
                    print("could not convert \(json[key]) to \(type)")
                    continue
                }
                object.setValue(value, forKey: key)
                print("\(key) set to \(value)")
                
            case PropertyTypes.OptionalUIImage.rawValue:
                print("\(key) is of type \(type)")
                guard let value = json[key] as? UIImage else {
                    continue
                }
                object.setValue(value, forKey: key)
                print("\(key) set to \(value)")
                
            
            // Not optionals, return nil if not set
            case PropertyTypes.String.rawValue:
                print("\(key) is of type \(type)")
                guard let value = json[key] as? String else {
                    return nil
                }
                object.setValue(value, forKey: key)
                print("\(key) set to \(value)")
            case PropertyTypes.Int.rawValue:
                print("\(key) is of type \(type)")
                var value = json[key] as? Int
                if value == nil {
                    guard let stringValue = json[key] as? String else {
                        print("could not convert \(json[key]) to string")
                        return nil
                    }
                    value = Int(stringValue)
                }
                guard value != nil else {
                    print("could not convert \(json[key]) to \(type)")
                    return nil
                }
                object.setValue(value, forKey: key)
                print("\(key) set to \(value)")
                
            case PropertyTypes.Bool.rawValue:
                NSLog("ERROR: \(key) is of type \(type). Currently Swift creates errors when using optional bools")
                print("\(key) is of type \(type)")
                guard let value = json[key] as? Bool else {
                    continue
                }
                object.setValue(value, forKey: key)
                print("\(key) set to \(value)")
            
                
            case PropertyTypes.OptionalNSDate.rawValue:
                print("\(key) is of type \(type)")
                guard let value = json[key] as? NSDate else {
                    print("could not convert \(json[key]) to Date string")
                    continue
                }
                object.setValue(value, forKey: key)
                print("\(key) set to \(value)")

                
                
                
            default:
                print("\(key) of type \(type) was not mapped")
            }
        }
        print("\nEnd\n")
        return object
    }
    
    class public func map(jsonArray jsonArray:[[String: AnyObject]], toObjectsCreatedByFactoryMethod objectFactoryMethod: ()->AnyObject) -> [AnyObject]? {
        var results = [AnyObject]()
        for json in jsonArray {
            guard let instance = map(json: json, toObjectInstance: objectFactoryMethod()) else {
                print("Could not map \(json)")
                continue
            }
            results.append(instance)
        }
        return results
    }
    
    class public func mapTemp(json json:AnyObject, withKey key:String, toObjectInstance object: AnyObject) -> AnyObject? {
        guard let jsonArray = Json.unserialize(json[key]) as? NSArray else {
            print("Server response did send an array")
            return false
        }
        guard let jsonIndividual = jsonArray[0] as? [String:AnyObject] else {
            print("Server response did not send dictionary with key \(key)")
            return false
        }
        return map(json: jsonIndividual, toObjectInstance: object)
    }
    class public func getSuccess(results: ApiResponse) -> Bool {
        guard let json = Json.unserialize(results.response) as? [String:AnyObject] else {
            print("Server response not in form [String:AnyObject]")
            return false
        }
        guard let success = json["success"] as? Bool else {
            print("response did not have a success variable")
            return false
        }
        return success
    }
//    class public func map(json json:AnyObject, withKey key:String, toObjectInstance object: AnyObject) -> AnyObject? {
//        guard let jsonValue = Json.unserialize(json[key]) as? [String:AnyObject] else {
//            print("Server response did not send dictionary with key \(key)")
//            return false
//        }
//        return map(json: jsonValue, toObjectInstance: object)
//    }
}