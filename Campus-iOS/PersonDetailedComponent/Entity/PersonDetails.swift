//
//  PersonDetails.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.02.22.
//

import Foundation
import SwiftUI

struct PersonDetails: Decodable {
    let nr: String
    let obfuscatedID: String
    var personGroup: String? {
        let split = obfuscatedID.split(separator: "*")
        guard let group = split.first, split.count == 2 else { return nil }
        return String(group)
    }
    var id: String? {
        let split = obfuscatedID.split(separator: "*")
        guard let id = split.last, split.count == 2 else { return nil }
        return String(id)
    }
    let firstName: String
    let name: String
    let title: String?
    let email: String
    let gender: Gender
    let officeHours: String?
    let officialContact: [ContactInfo]
    let privateContact: [ContactInfo]
    let image: UIImage?
    let organisations: [Organisation]
    let rooms: [Room]
    let phoneExtensions: [PhoneExtension]


    enum CodingKeys: String, CodingKey {
        case nr
        case obfuscatedID = "obfuscated_id"
        case firstName = "vorname"
        case name = "familienname"
        case title = "titel"
        case email
        case gender = "geschlecht"
        case officeHours = "sprechstunde"
        case officialContact = "dienstlich"
        case privateContact = "privat"
        case imageData = "image_data"
        case organisationContainer = "gruppen"
        case roomContainer = "raeume"
        case phoneExtensionContainer = "telefon_nebenstellen"
    }

    private struct OrganisationContainer: Decodable {
        let organisations: [Organisation]

        enum CodingKeys: String, CodingKey {
            case organisations = "gruppe"
        }
    }

    private struct PhoneExtensionContainer: Decodable {
        let phoneExtensions: [PhoneExtension]

        enum CodingKeys: String, CodingKey {
            case phoneExtensions = "nebenstelle"
        }
    }

    private struct RoomContainer: Decodable {
        let rooms: [Room]

        enum CodingKeys: String, CodingKey {
            case rooms = "raum"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.name = try container.decode(String.self, forKey: .name)

        if let title = try container.decodeIfPresent(String.self, forKey: .title), !title.isEmpty {
            self.title = title
        } else {
            self.title = nil
        }

        self.email = try container.decode(String.self, forKey: .email)

        self.nr = try container.decode(String.self, forKey: .nr)
        self.obfuscatedID = try container.decode(String.self, forKey: .obfuscatedID)
        self.gender = try container.decode(Gender.self, forKey: .gender)
        self.officeHours = try container.decode(String.self, forKey: .officeHours)

        self.officialContact = try container.decode([String: String].self, forKey: .officialContact).compactMap { ContactInfo(key: $0.key, value: $0.value) }
        self.privateContact = try container.decode([String: String].self, forKey: .privateContact).compactMap { ContactInfo(key: $0.key, value: $0.value) }
        
        if let imageString = try container.decodeIfPresent(String.self, forKey: .imageData), let imageData = Data(base64Encoded: imageString, options: [.ignoreUnknownCharacters]), let uiImage = UIImage(data: imageData)  {
            self.image = uiImage
        } else {
            self.image = nil
        }

        self.organisations = try container.decodeIfPresent(OrganisationContainer.self, forKey: .organisationContainer)?.organisations ?? []
        self.rooms = try container.decodeIfPresent(RoomContainer.self, forKey: .roomContainer)?.rooms ?? []
        self.phoneExtensions = try container.decodeIfPresent(PhoneExtensionContainer.self, forKey: .phoneExtensionContainer)?.phoneExtensions ?? []
    }
}
