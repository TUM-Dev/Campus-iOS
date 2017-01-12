//
//  JSON.swift
//  Pods
//
//  Created by Mathias Quintero on 12/21/16.
//
//

import Foundation

/// JSON Object
public enum JSON {
    
    case dict([String:JSON])
    case array([JSON])
    case string(String)
    case bool(Bool)
    case double(Double)
    case object(Serializable)
    case null
    
    /// Access dictionary
    public subscript(key: String) -> JSON {
        return dict | key ?? .null
    }
    
    /// Access array
    public subscript(index: Int) -> JSON {
        return array | index ?? .null
    }
    
}

public extension JSON {
    
    /// Internal Value stored
    var value: Any {
        switch self {
        case .dict(let value):
            return value
        case .array(let value):
            return value
        case .string(let value):
            return value
        case .bool(let value):
            return value
        case .double(let value):
            return value
        case .object(let value):
            return value
        case .null:
            return NSNull()
        }
    }
    
    /// Get Casted Value
    func get<T>() -> T? {
        guard let item = value as? T else {
            return nil
        }
        return item
    }
    
    /// Get object inside JSON object by following a path
    public func get<T>(in path: [String], using mapper: (JSON) -> T?) -> T? {
        if let key = path.first {
            return self[key].get(in: path || [0], using: mapper)
        }
        return mapper(self)
    }
    
    /// Get Deserializable Object in Path
    public func get<T: Deserializable>(in path: [String]) -> T? {
        return get(in: path, using: T.init)
    }
    
    /// Get Deserializable Object in Path
    public func get<T: Deserializable>(in path: String...) -> T? {
        return get(in: path)
    }
    
    /// Get Array of objects in Path
    public func getAll<T>(in path: [String], using mapper: (JSON) -> T?) -> [T]? {
        if let key = path.first {
            return self[key].getAll(in: path || [0], using: mapper)
        }
        guard let array = array else {
            return nil
        }
        return array ==> mapper
    }
    
    /// Get Array of Deserializable Object in Path with internal Path inside array
    public func getAll<T: Deserializable>(in path: [String], for internalPath: [String] = []) -> [T]? {
        return getAll(in: path, using: T.initializer(for: internalPath))
    }
    
    /// Get Array of Deserializable Object in Path
    public func getAll<T: Deserializable>(in path: String...) -> [T]? {
        return getAll(in: path)
    }
    
}

extension JSON {
    
    /// Serialize non-serialized objects to fully fledged JSON
    public var serialized: JSON {
        switch self {
        case .object(let value):
            return value.json
        case .array(let value):
            return .array(value => { $0.serialized })
        case .dict(let value):
            return .dict(value >>= mapLast { $0.serialized })
        default:
            return self
        }
    }
    
    /// Turn into Object for Data serialization
    public var object: Any {
        let json = self.serialized
        switch json {
        case .array(let value):
            return value => { $0.object }
        case .dict(let value):
            return value >>= mapLast { $0.object }
        default:
            return json.value
        }
    }
    
}

extension JSON {
    
    /// Get underlying String
    public var string: String? {
        let value: CustomStringConvertible? = get()
        return value?.description
    }
    
    /// Get underlying Int
    public var int: Int? {
        return double | Int.init
    }
    
    /// Get underlying Double
    public var double: Double? {
        return get()
    }
    
    /// Get underlying Bool
    public var bool: Bool? {
        return get()
    }
    
    /// Get underlying Array
    public var array: [JSON]? {
        return get()
    }
    
    /// Get underlying Dictinary
    public var dict: [String:JSON]? {
        return get()
    }
    
    /// Get underlying Date
    public func date(using format: String = "dd.MM.yyyy hh:mm:ss a") -> Date? {
        return string?.date(using: format)
    }
    
}

extension JSON {
    
    /// Initialize from deserialized Swift JSON Dictionary or Array
    public init?(from value: Any) {
        if let dictionary = value as? [String:Any] {
            let dict = dictionary.dictionaryWithoutOptionals(byDividingWith: mapLast(with: JSON.init))
            self = .dict(dict)
            return
        }
        if let array = value as? [Any] {
            self = .array(array ==> JSON.init)
            return
        }
        if let string = value as? String {
            self = .string(string)
            return
        }
        if let double = value as? Double {
            self = .double(double)
            return
        }
        return nil
    }
    
    /// Initialize from Data and options
    public init?(data: Data, options: JSONSerialization.ReadingOptions) {
        guard let data = try? JSONSerialization.jsonObject(with: data, options: options) else {
            return nil
        }
        self.init(from: data)
    }
    
    /// Initialize from Serializable
    public init(from serializable: Serializable) {
        self = serializable.json
    }
    
}

extension JSON: DataRepresentable {
    
    /// Initialize from Data
    public init?(data: Data) {
        self.init(data: data, options: .allowFragments)
    }
    
    public var contentType: String? {
        return "application/json"
    }
    
}

extension JSON: DataSerializable {
    
    public static var accept: String? {
        return "application/json"
    }
    
    /// Get data
    public var data: Data? {
        let object = self.object
        return try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
    }
    
}

extension JSON: Serializable {
    
    /// Get JSON to send
    public var json: JSON {
        return serialized
    }
    
}
