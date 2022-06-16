//
//  MapViewModel+State.swift
//  Campus-iOS
//
//  Created by David Lin on 14.05.22.
//

import Foundation

extension MapViewModel {
    enum CafeteriasNetworkState {
        // to make it Equitable
//        static func == (lhs: MapViewModel.CafeteriasNetworkState, rhs: MapViewModel.CafeteriasNetworkState) -> Bool {
//            switch (lhs, rhs) {
//            case (.na, .na):
//                return true
//            case (.loading, .loading):
//                return true
//            case (.failed(error: _), .failed(error: _)):
//                return true
//            case (.success(data: let lhsData), .success(data: let rhsData)):
//                return lhsData == rhsData
//            default:
//                return false
//            }
//        }
        
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
