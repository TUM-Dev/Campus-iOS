//
//  StudyRoomWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 25.06.22.
//

import SwiftUI
import MapKit

struct StudyRoomWidgetView: View {
    
    @StateObject var viewModel = StudyRoomWidgetViewModel(studyRoomService: StudyRoomsService())
    @State private var size: WidgetSize
    @State private var showDetails = false
    private let initialSize: WidgetSize
    @State private var scale: CGFloat = 1
    @Binding var refresh: Bool
    
    init(size: WidgetSize, refresh: Binding<Bool> = .constant(false)) {
        self._size = State(initialValue: size)
        self.initialSize = size
        self._refresh = refresh
    }
    
    var content: some View {
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
                    StudyRoomWidgetContent(
                        size: size,
                        name: name,
                        rooms: rooms,
                        coordinate: coordinate
                    )
                    .background {
                        WidgetMapBackgroundView(coordinate: coordinate, size: size)
                    }
                } else {
                    TextWidgetView(text: "No nearby study rooms.")
                }
            }
        }
    }
    
    var body: some View {
        WidgetFrameView(size: size, content: content)
            .onChange(of: refresh) { _ in
                if showDetails { return }
                Task { await viewModel.fetch() }
            }
            .task {
                await viewModel.fetch()
            }
            .onTapGesture {
                showDetails.toggle()
            }
            .sheet(isPresented: $showDetails) {
                NavigationView { // To enable navigation to the map images.
                    StudyRoomGroupView(
                        vm: MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService()),
                        selectedGroup: $viewModel.studyGroup,
                        rooms: viewModel.rooms ?? [],
                        canDismiss: false
                    )
                }
            }
            .expandable(size: $size, initialSize: initialSize, scale: $scale)
    }
}

struct StudyRoomWidgetContent: View {
    
    let size: WidgetSize
    let name: String
    let rooms: [StudyRoom]
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        switch (size) {
        case .square, .rectangle:
            SimpleStudyRoomWidgetContent(
                studyGroup: name,
                freeRooms: rooms.filter{ $0.isAvailable() }.count,
                coordinate: coordinate,
                size: size
            )
        case .bigSquare:
            DetailedStudyRoomWidgetContent(
                studyGroup: name,
                rooms: rooms,
                coordinate: coordinate,
                size: size
            )
        }
    }
}

/* Content implementations */

struct SimpleStudyRoomWidgetContent: View {
    
    let studyGroup: String
    let freeRooms: Int
    let coordinate: CLLocationCoordinate2D
    let size: WidgetSize
        
    var body: some View {
        VStack(alignment: .leading) {
            StudyRoomWidgetHeaderView(count: freeRooms, studyGroup: studyGroup, allowMultiline: true)
            Spacer()
        }
        .padding()
    }
}

struct DetailedStudyRoomWidgetContent: View {
    
    let studyGroup: String
    let rooms: [StudyRoom]
    let coordinate: CLLocationCoordinate2D
    let size: WidgetSize
    
    private let DISPLAYED_ROOMS = 5
    
    init(studyGroup: String, rooms: [StudyRoom], coordinate: CLLocationCoordinate2D, size: WidgetSize) {
        self.studyGroup = studyGroup
        self.coordinate = coordinate
        
        // Display available rooms first.
        self.rooms = rooms.sorted { r1, _ in
            return r1.isAvailable()
        }
        self.size = size
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            StudyRoomWidgetHeaderView(count: rooms.filter{ $0.isAvailable() }.count, studyGroup: studyGroup)
                .padding(.bottom, 16)
            
            Spacer()
            
            ForEach(rooms.prefix(DISPLAYED_ROOMS), id: \.id) { room in
                RoomDetailsView(room: room)
                    .padding(.bottom, 2)
            }
            
            Spacer()
        }
        .padding()
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
                Image(systemName: "book")
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
        coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42),
        size: .square
    )
    
    static var detailedContent = DetailedStudyRoomWidgetContent(
        studyGroup: "StudiTUM Weihenstephan",
        rooms: [StudyRoom](repeating: StudyRoom(), count: 12),
        coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42),
        size: .bigSquare
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
