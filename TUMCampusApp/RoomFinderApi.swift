//
//  RoomFinderApi.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
enum RoomFinderApi: String {
    case BaseUrl = "http://vmbaumgarten3.informatik.tu-muenchen.de/roommaps/room"
    case SearchRooms = "/search"
    case Maps = "/availableMaps"
    case MapImage = "/map"
}