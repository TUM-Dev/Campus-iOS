//
//  RoomFinderApi.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
enum RoomFinderApi: String {
    case BaseUrl = "https://tumcabe.in.tum.de/Api/roomfinder/"
    case SearchRooms = "room/search/"
    case Maps = "room/availableMaps/"
    case MapImage = "room/map/"
}
