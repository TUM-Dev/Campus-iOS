//
//  StudyRoom.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation
import SwiftUI

struct StudyRoom: Entity, Identifiable, Searchable {
    
    static func == (lhs: StudyRoom, rhs: StudyRoom) -> Bool {
        lhs.id == rhs.id
    }
    
    var comparisonTokens: [ComparisonToken] {
        get {
            return [
                ComparisonToken(value: name ?? ""),
                ComparisonToken(value: buildingCode ?? "", type: .raw),
                ComparisonToken(value: buildingName ?? ""),
                ComparisonToken(value: String(buildingNumber), type: .raw),
                ComparisonToken(value: status ?? ""),
                ComparisonToken(value: occupiedBy ?? "")
            ] + (attributes?.flatMap { $0.comparisonTokens } ?? [])
        }
    }
    
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
    
    var localizedStatus: String {
        switch self.status {
        case "frei":
            return "Free"
        case "belegt":
            if let occupiedUntilString = self.occupiedUntil, let occupiedUntilDate = StudyRoom.dateFomatter.date(from: occupiedUntilString) {
                return "\("Occupied until".localized) \(StudyRoom.secondDateFormatter.string(from: occupiedUntilDate))"
            }
        default:
            return "Unknown"
        }
        
        return ""
    }
    
    var localizedStatusText: Text {
        
        let color: Color
        
        switch self.status {
        case "frei":
            color = .green
        case "belegt":
            color = .red
        default:
            color = .gray
        }
        
        return Text(localizedStatus).foregroundColor(color)
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
    
    static let dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    static let secondDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    func isAvailable() -> Bool {
        return status == "frei"
    }
    
    init(buildingCode: String? = nil, buildingName: String? = nil, buildingNumber: Int64, code: String? = nil, id: Int64, name: String? = nil, number: String? = nil, occupiedBy: String? = nil, occupiedFor: Int64, occupiedFrom: String? = nil, occupiedIn: Int64, occupiedUntil: String? = nil, raum_nr_architekt: String? = nil, res_nr: Int64, status: String? = nil, attributes: [StudyRoomAttribute]? = nil) {
        self.buildingCode = buildingCode
        self.buildingName = buildingName
        self.buildingNumber = buildingNumber
        self.code = code
        self.id = id
        self.name = name
        self.number = number
        self.occupiedBy = occupiedBy
        self.occupiedFor = occupiedFor
        self.occupiedFrom = occupiedFrom
        self.occupiedIn = occupiedIn
        self.occupiedUntil = occupiedUntil
        self.raum_nr_architekt = raum_nr_architekt
        self.res_nr = res_nr
        self.status = status
        self.attributes = attributes
    }
}
