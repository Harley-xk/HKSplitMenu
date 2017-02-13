//
//  Model.swift
//  HKSplitMenu
//
//  Created by Harley on 2017/1/10.
//  Copyright © 2017年 Sinoyd. All rights reserved.
//

import UIKit
import Comet
import ObjectMapper

class Model: NSObject, Mappable {

//    var id = 0
//    var updated_at: Date?
//    var created_at: Date?
//    var deleted_at: Date?

    override init() {}
    required public init?(map: Map) {}

    func mapping(map: Map) {
        autoMapping(map: map)
    }
    
    func customMappings() -> [String:String] {
        return [:]
    }
    
    func dateTransform(for keyPath:String) -> TimeConvertor {
        return TimeConvertor()
    }
    
    private func autoMapping(map: Map) {
        let mirror = Mirror(reflecting: self)
        self.process(mirror: mirror,map: map)
    }
    
    private func process(mirror: Mirror,map: Map) {
        
        for child in mirror.children {
            autoMap(child: child, withMap: map)
        }
        
        if let superMirror = mirror.superclassMirror {
            process(mirror: superMirror,map: map)
        }
    }
    
    private func autoMap(child: Mirror.Child, withMap map: Map) {
        
        guard let name = child.label else {
            return
        }
        
        let mi = Mirror(reflecting: child.value)
        let key = customMappings()[name] ?? name
        
        guard let rawValue = map.JSON[key], !(rawValue is NSNull) else {
            return
        }

        // Auto mapping String
        if mi.subjectType == String.self {
            if let value = try? map.value(key) as String {
                setValue(value, forKeyPath: name)
            }
        }
            
        // Auto mapping String Array
        if mi.subjectType == [String].self {
            if let value = try? map.value(key) as [String] {
                setValue(value, forKeyPath: name)
            }
        }
            
        // Auto mapping Int
        else if mi.subjectType == Int.self {
            if let value = try? map.value(key) as Int {
                setValue(value, forKeyPath: name)
            }
        }
            
        // Auto mapping Double
        else if mi.subjectType == Double.self {
            if let value = try? map.value(key) as Double {
                setValue(value, forKeyPath: name)
            }
        }
            
        // Auto mapping Date
        else if mi.subjectType == Date?.self ||
                mi.subjectType == Date.self
        {
            let transform = dateTransform(for: name)
            if let value = try? map.value(key, using: transform) as Date {
                setValue(value, forKeyPath: name)
            }
        }
        
        else {
//            setValue(rawValue, forKeyPath: name)
        }
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        RunDebug {
//            print("Auto Mapping", self.classForCoder.description(), "======")
//            print("UndefinedKey: ", key)
////            print("       Value: ", value ?? "nil")
//            print("")
//        }
    }
}

public class TimeConvertor: TransformType {
    
    public typealias Object = Date
    public typealias JSON = Any
    
    private var format: String
    
    public init(format: String = "yyyy-MM-dd HH:mm:ss") {
        self.format = format
    }
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInterval = value as? TimeInterval {
            return Date(timeIntervalSince1970: timeInterval)
        }
        
        if let timeString = value as? String {
            return Date(string: timeString, format: format)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Date?) -> Any? {
        return value?.string()
    }
}

