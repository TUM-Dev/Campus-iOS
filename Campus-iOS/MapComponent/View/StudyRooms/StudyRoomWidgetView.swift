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
                StudyRoomWidgetErrorContent()
            case .loading:
                WidgetLoadingView(text: "Searching nearby study rooms")
            default:
                if let studyGroup = viewModel.studyGroup,
                   let rooms = viewModel.rooms {
                    
                    switch (size) {
                    case .square, .rectangle:
                        SimpleStudyRoomWidgetContent(
                            studyGroup: studyGroup,
                            freeRooms: rooms.filter{ $0.status == "frei" }.count
                        )
                    case .bigSquare:
                        DetailedStudyRoomWidgetContent(studyGroup: studyGroup, rooms: rooms)
                    }
                } else {
                    StudyRoomWidgetErrorContent()
                }
            }
        }
        .task {
            await viewModel.fetch()
        }
        
    }
}

/* Content implementations */

struct StudyRoomWidgetErrorContent: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
            .overlay {
                Text("No nearby study rooms.")
                    .foregroundColor(.white)
            }
    }
}

struct SimpleStudyRoomWidgetContent: View {
    
    let studyGroup: String
    let freeRooms: Int
        
    var body: some View {
        Rectangle()
            .foregroundColor(freeRooms > 0 ? .green : .red)
            .overlay {
                VStack(alignment: .leading) {
                    RoomCountView(count: freeRooms, textColor: .white)
                    Spacer()
                    RoomCountCaptionView(studyGroup: studyGroup, textColor: .white)
                }
                .padding()
            }
    }
}

struct DetailedStudyRoomWidgetContent: View {
    
    let studyGroup: String
    let rooms: [StudyRoom]
    
    private let DISPLAYED_ROOMS = 5
    
    init(studyGroup: String, rooms: [StudyRoom]) {
        self.studyGroup = studyGroup
        
        // Display available rooms first.
        self.rooms = rooms.sorted { r1, _ in
            return r1.status == "frei"
        }
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(rooms.count > 0 ? .green : .red)
            .overlay {
                VStack(alignment: .leading) {
                    RoomCountView(count: rooms.count, textColor: .white)
                    RoomCountCaptionView(studyGroup: studyGroup, textColor: .white)
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
    let textColor: Color
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(String(count))
                .bold()
                .font(.system(size: 70))
                .foregroundColor(textColor)
                .layoutPriority(1) // Other texts get truncated first.
            
            Text(count == 1 ? "room" : "rooms")
                .lineLimit(1)
                .font(.system(size: 11))
                .foregroundColor(textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RoomCountCaptionView: View {
    let studyGroup: String
    let textColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("available at")
                .font(.system(size: 11))
                .foregroundColor(.white)
            Text(studyGroup)
                .bold()
                .lineLimit(1)
                .font(.system(size: 11))
                .foregroundColor(.white)
        }
    }
}

struct RoomDetailsView: View {
    
    let room: StudyRoom
    
    var body: some View {
        HStack {
            Text(room.name ?? "Unknown room")
                .bold()
                .foregroundColor(.white)
            
            Spacer()
            
            Group {
                if (room.status == "frei") {
                    Label(room.code ?? "Unknown", systemImage: "barcode.viewfinder")
                } else {
                    Label(room.localizedStatus, systemImage: "clock")
                }
            }
            .foregroundColor(.white)
            .layoutPriority(1) // Truncate room name first
        }
    }
}

/* Previews */

struct StudyRoomWidgetView_Previews: PreviewProvider {
    
    static var content: some View {
        VStack {
            HStack{
                WidgetFrameView(size: .square, content: SimpleStudyRoomWidgetContent(studyGroup: "StudiTUM Weihenstephan", freeRooms: 0))
                
                WidgetFrameView(size: .square, content: SimpleStudyRoomWidgetContent(studyGroup: "StudiTUM Weihenstephan", freeRooms: 1))
            }

            WidgetFrameView(size: .rectangle, content: SimpleStudyRoomWidgetContent(studyGroup: "StudiTUM Weihenstephan", freeRooms: 42))
            WidgetFrameView(size: .bigSquare, content: DetailedStudyRoomWidgetContent(studyGroup: "StudiTUM Weihenstephan", rooms: [StudyRoom](repeating: StudyRoom(), count: 12)))
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
    }
}
