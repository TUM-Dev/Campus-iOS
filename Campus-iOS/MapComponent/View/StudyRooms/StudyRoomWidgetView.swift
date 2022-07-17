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
                    StudyRoomWidgetHeaderView(count: freeRooms, studyGroup: studyGroup, allowMultiline: true)
                    Spacer()
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
                    StudyRoomWidgetHeaderView(count: rooms.filter{ $0.isAvailable() }.count, studyGroup: studyGroup)
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

struct StudyRoomWidgetHeaderView: View {
    
    let count: Int
    let studyGroup: String
    let allowMultiline: Bool
    
    init(count: Int, studyGroup: String, allowMultiline: Bool = false) {
        self.count = count
        self.studyGroup = studyGroup
        self.allowMultiline = allowMultiline
    }
    
    var body: some View {
        
        let textColor: Color = count > 0 ? .green : .red
        
        VStack(alignment: .leading) {
            
            HStack {
                Image(systemName: "house")
                Text(studyGroup)
                    .bold()
                    .lineLimit(2)
            }
            .foregroundColor(.primary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 2)
            
            Label(String(count), systemImage: "book")
                .font(.system(size: 35).bold())
            
            Text((count == 1 ? "room" : "rooms") + " available")
                .lineLimit(1)
        }
        .foregroundColor(textColor)
        .frame(maxWidth: .infinity, alignment: .leading)
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
