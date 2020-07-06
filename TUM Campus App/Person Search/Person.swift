//
//  Person.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 2.7.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import Foundation

enum Gender: Decodable, Hashable {
    case male
    case female
    case nonBinary
    case unkown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        switch try container.decode(String.self) {
        case "M", "m": self = .male
        case "F", "f": self = .female
        default: self = .unkown
        }
    }
}

struct Person: Decodable, Hashable {
    let firstName: String
    let name: String
    let title: String?
    let nr: String
    let obfuscatedID: String
    let gender: Gender
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

    /*
     <vorname>Tim</vorname>
     <familienname>Gymnich</familienname>
     <titel isnull="true"></titel>
     <nr>-1870402</nr>
     <geschlecht>M</geschlecht>
     <obfuscated_id>5*B551662E7E3AD2CB</obfuscated_id>
     <bild_url>visitenkarte.showImage?pPersonenGruppe=5&amp;pPersonenId=B551662E7E3AD2CB</bild_url>
     */

    enum CodingKeys: String, CodingKey {
        case firstName = "vorname"
        case name = "familienname"
        case title = "titel"
        case nr
        case obfuscatedID = "obfuscated_id"
        case gender = "geschlecht"
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
        self.nr = try container.decode(String.self, forKey: .nr)
        self.obfuscatedID = try container.decode(String.self, forKey: .obfuscatedID)
        self.gender = try container.decode(Gender.self, forKey: .gender)
    }

}
