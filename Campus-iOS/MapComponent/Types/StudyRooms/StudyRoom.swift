//
//  StudyRoom.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation
import SwiftUI

struct StudyRoom: Entity {
    var buildingCode: String?
    var buildingName: String?
    var buildingNumber: Int64
    var code: String?
    var id: Int64
    var name: String?
    var number: String?
    var occupiedBy: String?
    var occupiedFor: Int64
    var occupiedFrom: String?
    var occupiedIn: Int64
    var occupiedUntil: String?
    var raum_nr_architekt: String?
    var res_nr: Int64
    var status: String?
    var attributes: [StudyRoomAttribute]?
    
    var localizedStatus: Text {
        switch self.status {
        case "frei":
            return Text("Free")
                .foregroundColor(.green)
        case "belegt":
            if let occupiedUntilString = self.occupiedUntil, let occupiedUntilDate = StudyRoom.dateFomatter.date(from: occupiedUntilString) {
                return Text("\("Occupied until".localized) \(StudyRoom.secondDateFormatter.string(from: occupiedUntilDate))")
                    .foregroundColor(.red)
            }
        default:
            return Text("Unknown")
                .foregroundColor(.gray)
        }
        return Text("")
    }

    enum CodingKeys: String, CodingKey {
        case occupiedFrom = "belegung_ab"
        case occupiedUntil = "belegung_bis"
        case occupiedBy = "belegung_durch"
        case occupiedFor = "belegung_fuer"
        case occupiedIn = "belegung_in"
        case buildingCode = "gebaeude_code"
        case buildingName = "gebaeude_name"
        case buildingNumber = "gebaeude_nr"
        case code = "raum_code"
        case name = "raum_name"
        case id = "raum_nr"
        case raum_nr_architekt = "raum_nr_architekt"
        case number = "raum_nummer"
        case res_nr = "res_nr"
        case status = "status"
        case attributes = "attribute"
    }
    
    init() {
        self.buildingNumber = 0
        self.id = 0
        self.occupiedFor = 0
        self.occupiedIn = 0
        self.res_nr = 0
    }
    
    init(room fromFinder: FoundRoom) {
        self.raum_nr_architekt = fromFinder.id
        self.buildingNumber = 0
        self.id = 0
        self.occupiedFor = 0
        self.occupiedIn = 0
        self.res_nr = 0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let occupiedFrom = try container.decode(String.self, forKey: .occupiedFrom)
        let occupiedUntil = try container.decode(String.self, forKey: .occupiedUntil)
        let occupiedBy = try container.decode(String.self, forKey: .occupiedBy)
        let occupiedFor = try container.decode(Int64.self, forKey: .occupiedFor)
        let occupiedIn = try container.decode(Int64.self, forKey: .occupiedIn)
        let buildingCode = try container.decode(String.self, forKey: .buildingCode)
        let buildingName = try container.decode(String.self, forKey: .buildingName)
        let buildingNumber = try container.decode(Int64.self, forKey: .buildingNumber)
        let code = try container.decode(String.self, forKey: .code)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(Int64.self, forKey: .id)
        let raum_nr_architekt = try container.decode(String.self, forKey: .raum_nr_architekt)
        let number = try container.decode(String.self, forKey: .number)
        let res_nr = try container.decode(Int64.self, forKey: .res_nr)
        let status = try container.decode(String.self, forKey: .status)
        let attributes = try container.decode([StudyRoomAttribute].self, forKey: .attributes)

        self.occupiedFrom = occupiedFrom
        self.occupiedUntil = occupiedUntil
        self.occupiedBy = occupiedBy
        self.occupiedFor = occupiedFor
        self.occupiedIn = occupiedIn
        self.buildingCode = buildingCode
        self.buildingName = buildingName
        self.buildingNumber = buildingNumber
        self.code = code
        self.name = name
        self.id = id
        self.raum_nr_architekt = raum_nr_architekt
        self.number = number
        self.res_nr = res_nr
        self.status = status
        self.attributes = attributes
    }
    
    private static let dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    private static let secondDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
