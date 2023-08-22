//
//  NavigationEntity.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//
import Foundation

struct NavigaTumNavigationEntity: Codable, Identifiable, Equatable {
    let id: String
    let type: String
    let name: String
    let subtext: String
    let parsedId: String?

    enum CodingKeys: String, CodingKey {
        case id, type, name, subtext
        case parsedId = "parsed_id"
    }

    func getFormattedName() -> String {
        guard let parsedId = parsedId else {
            return removeHighlight(name)
        }

        return removeHighlight(parsedId) + " ➤ " + removeHighlight(name)
    }

    func getFormattedSubtext() -> String {
        return removeHighlight(subtext)
    }

    private func removeHighlight(_ field: String) -> String {
        /***
         * Info from NavigaTum swagger: https://editor.swagger.io/?url=https://raw.githubusercontent.com/TUM-Dev/navigatum/main/openapi.yaml
         * In future maybe there will be query parameter for this
         * "Some fields support highlighting the query terms and it uses DC3 (\x19 or \u{0019})
         * and DC1 (\x17 or \u{0017}) to mark the beginning/end of a highlighted sequence"
         */
        field
            .replacingOccurrences(of: "\u{0019}", with: "")
            .replacingOccurrences(of: "\u{0017}", with: "")
            .replacingOccurrences(of: "\\x19", with: "")
            .replacingOccurrences(of: "\\x17", with: "")
    }
}
