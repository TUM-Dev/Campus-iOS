//
//  StudyRoomWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 25.06.22.
//

import SwiftUI

struct StudyRoomWidgetView: View {
    
    @StateObject var viewModel: StudyRoomWidgetViewModel
    
    var body: some View {
        VStack {
            switch(viewModel.status) {
            case .error:
                Text("No nearby study rooms.")
            case .loading:
                Text("Searching nearby study rooms.")
                ProgressView()
            default:
                
                if let studyGroup = viewModel.studyGroup, let rooms = viewModel.rooms {
                    Text(studyGroup)
                        .bold()
                    
                    Spacer()
                    
                    CompactStudyRoomView(rooms: rooms)
                    
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.fetch()
        }    }
}

struct CompactStudyRoomView: View {
    
    var rooms: [StudyRoom]
    @State private var roomIndex = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        if !rooms.isEmpty {
            
            HStack {
                Text(rooms[roomIndex].name ?? "Unknown room")
                
                Spacer()
                
                rooms[roomIndex].localizedStatus
            }
            .onReceive(self.timer) { _ in
                withAnimation {
                    roomIndex = (roomIndex + 1) % rooms.count
                }
            }
        } else {
            Text("No available study rooms.")
        }
    }
}

struct StudyRoomWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomWidgetView(viewModel: StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService()))
    }
}
