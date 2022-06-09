//
//  MapViewModel+State.swift
//  Campus-iOS
//
//  Created by David Lin on 14.05.22.
//

import Foundation

extension MapViewModel {
    enum CafeteriasNetworkState {
        case na
        case loading
        case success(data: [Cafeteria])
        case failed(error: Error)
    }
    
    enum StudyRoomsNetworkState {
        case na
        case loading
        case success(data: StudyRoomApiRespose)
        case failed(error: Error)
    }
}
