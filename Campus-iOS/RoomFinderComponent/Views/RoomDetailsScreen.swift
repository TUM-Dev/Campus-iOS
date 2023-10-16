//
//  RoomDetailsScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 09.06.23.
//

import SwiftUI

struct RoomDetailsScreen: View {
    
    var room: NavigaTumNavigationEntity
    @StateObject var vm: NavigaTumDetailsViewModel
    
    init(room: NavigaTumNavigationEntity) {
        self.room = room
        self._vm = StateObject(wrappedValue: NavigaTumDetailsViewModel(id: room.id))
    }
    
    var body: some View {
        Group {
            if let details = vm.details {
                LocationView(location: TUMLocation(room: self.room, details: details))
            } else {
                ProgressView()
            }
        }.task {
            await vm.fetchDetails()
        }
    }
}

