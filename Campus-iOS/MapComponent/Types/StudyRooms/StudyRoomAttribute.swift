//
//  StudyRoomAttribute.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation

class StudyRoomAttribute: NSObject, Entity, NSSecureCoding {

    var detail: String?
    var name: String?
    
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(detail, forKey: CodingKeys.detail.rawValue)
        coder.encode(name, forKey: CodingKeys.name.rawValue)
    }
    
    required init?(coder: NSCoder) {
        let detail = coder.decodeObject(of: NSString.self, forKey: CodingKeys.detail.rawValue)
        let name = coder.decodeObject(of: NSString.self, forKey: CodingKeys.name.rawValue)

        self.detail = detail as String?
        self.name = name as String?
    }

    enum CodingKeys: String, CodingKey {
        case detail
        case name
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let detail = try container.decode(String.self, forKey: .detail)
        let name = try container.decode(String.self, forKey: .name)

        self.detail = detail
        self.name = name
    }
}

@objc(StudyRoomAttributeValueTransformer)
final class StudyRoomAttributeValueTransformer: NSSecureUnarchiveFromDataTransformer {

    static let name = NSValueTransformerName(rawValue: String(describing: StudyRoomAttribute.self))

    // Make sure `CustomClass` is in the allowed class list,
    // AND any other classes that are encoded in `CustomClass`
    override static var allowedTopLevelClasses: [AnyClass] {
        // for example... yours may look different
        return [StudyRoomAttribute.self]
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
            guard let studyRoomAttribute = value as? StudyRoomAttribute else { return nil }
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: studyRoomAttribute, requiringSecureCoding: true)
                return data
            } catch {
                assertionFailure("Failed to transform `StudyRoomAttribute` to `Data`")
                return nil
            }
        }
        
        override public func reverseTransformedValue(_ value: Any?) -> Any? {
            guard let data = value as? NSData else { return nil }
            
            do {
                let studyRoomAttribute = try NSKeyedUnarchiver.unarchivedObject(ofClass: StudyRoomAttribute.self, from: data as Data)
                return studyRoomAttribute
            } catch {
                assertionFailure("Failed to transform `Data` to `StudyRoomAttribute`")
                return nil
            }
        }

    /// Registers the transformer.
    public static func register() {
        let transformer = StudyRoomAttributeValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
