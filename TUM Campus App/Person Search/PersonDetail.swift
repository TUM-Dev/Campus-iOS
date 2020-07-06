//
//  PersonDetail.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 4.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit
import XMLCoder

struct PersonDetail: Decodable {
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

    enum ContactInfo {
        case phone(String)
        case mobilePhone(String)
        case fax(String)
        case additionalInfo(String)
        case homepage(String)

        init?(key: String, value: String) {
            guard !value.isEmpty else { return nil }
            switch key {
            case "telefon": self = .phone(value)
            case "mobiltelefon": self = .mobilePhone(value)
            case "fax": self = .fax(value)
            case "zusatz_info": self = .additionalInfo(value)
            case "www_homepage": self = .homepage(value)
            default: return nil
            }
        }
    }

    private struct OrganisationContainer: Decodable {
        let organisations: [Organisation]

        enum CodingKeys: String, CodingKey {
            case organisations = "gruppe"
        }
    }

    struct Organisation: Decodable {
        let name: String
        let id: String
        let number: String
        let title: String
        let description: String

        enum CodingKeys: String, CodingKey {
            case name = "org"
            case id = "kennung"
            case number = "org_nr"
            case title = "titel"
            case description = "beschreibung"
        }
    }

    private struct PhoneExtensionContainer: Decodable {
        let phoneExtensions: [PhoneExtension]

        enum CodingKeys: String, CodingKey {
            case phoneExtensions = "nebenstelle"
        }
    }

    struct PhoneExtension: Decodable {
        let phoneNumber: String
        let countryCode: String
        let areaCode: String
        let equipmentNumber: String
        let branchNumber: String

        enum CodingKeys: String, CodingKey {
            case phoneNumber = "telefonnummer"
            case countryCode = "tum_anlage_land"
            case areaCode = "tum_anlage_ortsvorwahl"
            case equipmentNumber = "tum_anlage_nummer"
            case branchNumber = "tum_nebenstelle"
        }
    }

    private struct RoomContainer: Decodable {
        let rooms: [Room]

        enum CodingKeys: String, CodingKey {
            case rooms = "raum"
        }
    }

    struct Room: Decodable {
        let number: String
        let buildingName: String
        let buildingNumber: String
        let floorName: String
        let floorNumber: String
        let id: String
        let locationDescription: String
        let shortLocationDescription: String
        let longLocationDescription: String

        enum CodingKeys: String, CodingKey {
            case number = "nummer"
            case buildingName = "gebaeudename"
            case buildingNumber = "gebaeudenummer"
            case floorName = "stockwerkname"
            case floorNumber = "stockwerknummer"
            case id = "architekt"
            case locationDescription = "ortsbeschreibung"
            case shortLocationDescription = "kurz"
            case longLocationDescription = "lang"
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

        if let imageString = try container.decodeIfPresent(String.self, forKey: .imageData), let imageData = Data(base64Encoded: imageString)  {
            self.image = UIImage(data: imageData)
        } else {
            self.image = nil
        }

        self.organisations = try container.decodeIfPresent(OrganisationContainer.self, forKey: .organisationContainer)?.organisations ?? []
        self.rooms = try container.decodeIfPresent(RoomContainer.self, forKey: .roomContainer)?.rooms ?? []
        self.phoneExtensions = try container.decodeIfPresent(PhoneExtensionContainer.self, forKey: .phoneExtensionContainer)?.phoneExtensions ?? []
    }

}
