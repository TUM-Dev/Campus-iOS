//
//  StudyRoomWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 25.06.22.
//

import SwiftUI

struct StudyRoomWidgetView: View {
    
    let size: WidgetSize
    
    var body: some View {
        WidgetView(size: size, content: StudyRoomWidgetContentView(size: size))
    }
}

struct StudyRoomWidgetContentView: View {
    
    let size: WidgetSize
    @StateObject var viewModel = StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())

    var body: some View {
        VStack(alignment: .leading) {
            switch(viewModel.status) {
            case .error:
                Text("No nearby study rooms.")
            case .loading:
                Text("Searching nearby study rooms.")
                ProgressView()
            default:
                
                if let studyGroup = viewModel.studyGroup, let rooms = viewModel.rooms {
                    WidgetTitleView(title: studyGroup)
                        .padding(.bottom, 2)
                    
                    Spacer()
                                    
                    CompactStudyRoomView(
                        rooms: rooms.filter({ $0.status == "frei" }),
                        size: size
                    )
                    
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.fetch()
        }
    }
}

struct CompactStudyRoomView: View {
    
    let rooms: [StudyRoom]
    let size: WidgetSize
    
    private let displayedRooms: Int
    
    init(rooms: [StudyRoom], size: WidgetSize) {
        self.rooms = rooms
        self.size = size
        
        switch (size) {
        case .square, .rectangle:
            displayedRooms = 1
        case .bigSquare:
            displayedRooms = 5
        }
        
    }
    
    var body: some View {
        
        if !rooms.isEmpty {
            
            ForEach(rooms.prefix(displayedRooms), id: \.id) { room in
                HStack {
                    Text(room.name ?? "Unknown room")
                        .lineLimit(1)
                    
                    Spacer()
                    room.localizedStatus
                        .lineLimit(1)
                }
                .padding(.bottom, 2)
            }
                        
            let remainingRooms = rooms.count - displayedRooms
            if (remainingRooms > 0) {
                Spacer()
                Text("+ \(remainingRooms) more available room\(remainingRooms == 1 ? "" : "s")")
                    .foregroundColor(.green)
                    .bold()
            }
        } else {
            Text("No available study rooms.")
        }
    }
}

struct StudyRoomWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomWidgetView(size: .rectangle)
        StudyRoomWidgetView(size: .rectangle)
            .preferredColorScheme(.dark)
    }
}
