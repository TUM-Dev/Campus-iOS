//
//  NavigaTumSearchResponse.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//
import Foundation

struct NavigaTumSearchResponse: Codable {
    let id = UUID()
    let sections: [NavigaTumSearchResponseSection]

    enum CodingKeys: CodingKey {
        case sections
    }
}
