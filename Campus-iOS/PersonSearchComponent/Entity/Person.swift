//
//  Person.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 06.02.22.
//

import Foundation

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
    
    var fullName: String {
        "\(self.title?.appending(" ") ?? "")\(self.firstName.appending(" "))\(self.name)"
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
    
    init(firstName: String, lastName: String, title: String?, nr: String, obfuscatedId: String, gender: Gender) {
        self.firstName = firstName
        self.name = lastName
        self.title = title
        self.nr = nr
        self.obfuscatedID = obfuscatedId
        self.gender = gender
    }

}
