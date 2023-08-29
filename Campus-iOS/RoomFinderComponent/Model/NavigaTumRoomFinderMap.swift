//
//  RoomFinderMap.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 01.01.23.
//
import Foundation

struct NavigaTumRoomFinderMap: Codable, Identifiable {
    let id: String
    let name: String
    let imageUrl: String    // let baseMapUrl = "https://nav.tum.sexy/cdn/maps/roomfinder/"
    let height: Int
    let width: Int
    let x: Int
    let y: Int
    let scale: String

    enum CodingKeys: String, CodingKey {
        case id, name, height, width, x, y, scale
        case imageUrl = "file"
    }
}
