//
//  StudyRoomWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 25.06.22.
//

import SwiftUI
import MapKit

struct StudyRoomWidgetView: View {
    
    let size: WidgetSize
    
    var body: some View {
        WidgetFrameView(size: size, content: StudyRoomWidgetContent(size: size))
    }
}

struct StudyRoomWidgetContent: View {
    
    let size: WidgetSize
    @StateObject var viewModel = StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())
    
    var body: some View {
        Group {
            switch(viewModel.status) {
            case .error:
                TextWidgetView(text: "No nearby study rooms.")
            case .loading:
                WidgetLoadingView(text: "Searching nearby study rooms")
            default:
                if let name = viewModel.studyGroup?.name,
                   let rooms = viewModel.rooms,
                   let coordinate = viewModel.studyGroup?.coordinate {
                    
                    switch (size) {
                    case .square, .rectangle:
                        SimpleStudyRoomWidgetContent(
                            studyGroup: name,
                            freeRooms: rooms.filter{ $0.isAvailable() }.count,
                            coordinate: coordinate
                        )
                    case .bigSquare:
                        DetailedStudyRoomWidgetContent(
                            studyGroup: name,
                            rooms: rooms,
                            coordinate: coordinate
                        )
                    }
                } else {
                    TextWidgetView(text: "No nearby study rooms.")
                }
            }
        }
        .task {
            await viewModel.fetch()
        }
        
    }
}

/* Content implementations */

struct SimpleStudyRoomWidgetContent: View {
    
    let studyGroup: String
    let freeRooms: Int
    let coordinate: CLLocationCoordinate2D
        
    var body: some View {
        WidgetMapBackgroundView(coordinate: coordinate)
            .overlay {
                VStack(alignment: .leading) {
                    RoomCountView(count: freeRooms)
                    Spacer()
                    RoomCountCaptionView(studyGroup: studyGroup)
                }
                .padding()
            }
    }
}

struct DetailedStudyRoomWidgetContent: View {
    
    let studyGroup: String
    let rooms: [StudyRoom]
    let coordinate: CLLocationCoordinate2D
    
    private let DISPLAYED_ROOMS = 5
    
    init(studyGroup: String, rooms: [StudyRoom], coordinate: CLLocationCoordinate2D) {
        self.studyGroup = studyGroup
        self.coordinate = coordinate
        
        // Display available rooms first.
        self.rooms = rooms.sorted { r1, _ in
            return r1.isAvailable()
        }
    }
    
    var body: some View {
        WidgetMapBackgroundView(coordinate: coordinate)
            .overlay {
                VStack(alignment: .leading) {
                    RoomCountView(count: rooms.filter{ $0.isAvailable() }.count)
                    RoomCountCaptionView(studyGroup: studyGroup)
                        .padding(.bottom, 16)
                    
                    ForEach(rooms.prefix(DISPLAYED_ROOMS), id: \.id) { room in
                        RoomDetailsView(room: room)
                            .padding(.bottom, 2)
                    }
                    
                    Spacer()
                }
                .padding()
            }
    }
}

/* Helpers for the content */

struct RoomCountView: View {
    
    let count: Int
    
    var body: some View {
        
        let textColor: Color = count > 0 ? .green : .red
        
        HStack(alignment: .lastTextBaseline) {
            Text(String(count))
                .bold()
                .font(.system(size: 70))
                .layoutPriority(1) // Other texts get truncated first.
            
            Text(count == 1 ? "room" : "rooms")
                .lineLimit(1)
                .font(.system(size: 11))
        }
        .foregroundColor(textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RoomCountCaptionView: View {
    let studyGroup: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("available at")
                .font(.system(size: 11))
            Text(studyGroup)
                .bold()
                .lineLimit(1)
                .font(.system(size: 11))
        }
    }
}

struct RoomDetailsView: View {
    
    let room: StudyRoom
    
    var body: some View {
        HStack {
            Text(room.name ?? "Unknown room")
                .bold()
            
            Spacer()
            
            Group {
                if (room.isAvailable()) {
                    Label(room.code ?? "Unknown", systemImage: "barcode.viewfinder")
                } else {
                    Label(room.localizedStatus, systemImage: "clock")
                }
            }
            .foregroundColor(room.isAvailable() ? .green : .red)
            .layoutPriority(1) // Truncate room name first
        }
    }
}

/* Previews */

struct StudyRoomWidgetView_Previews: PreviewProvider {
    
    static var simpleContent = SimpleStudyRoomWidgetContent(
        studyGroup: "StudiTUM Weihenstephan",
        freeRooms: 42,
        coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42)
    )
    
    static var detailedContent = DetailedStudyRoomWidgetContent(
        studyGroup: "StudiTUM Weihenstephan",
        rooms: [StudyRoom](repeating: StudyRoom(), count: 12),
        coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42)
    )
    
    static var content: some View {
        VStack {
            HStack {
                WidgetFrameView(size: .square, content: simpleContent)
                
                WidgetFrameView(size: .square, content: simpleContent)
            }
            WidgetFrameView(size: .rectangle, content: simpleContent)
            WidgetFrameView(size: .bigSquare, content: detailedContent)
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
    }
}
