//
//  StudyRoomDetailsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 14.05.22.
//

import SwiftUI

struct StudyRoomDetailsView: View {
    @State var showPopup = false
    
    let room: StudyRoom
    let roomImageMapping: [RoomImageMapping]
    
    init(studyRoom room: StudyRoom, roomImageMapping: [RoomImageMapping]) {
        self.room = room
        self.roomImageMapping = roomImageMapping
    }
    
    func printCell(key: String, value: String?) -> some View {
        if let val = value {
            return AnyView(HStack {
                Text(key)
                    .foregroundColor(Color(UIColor.darkGray))
                Spacer()
                Text(val).foregroundColor(.gray)
            })
        }
        
        return AnyView(EmptyView())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            if self.roomImageMapping.count > 0 {
                HStack {
                    Image(systemName: "map.fill").foregroundColor(.highlightText)
                    Text("Available Maps")
                        .fontWeight(.bold)
                        .font(.headline)
                }
                MapImagesHorizontalScrollingView(room: self.room, roomImageMapping: self.roomImageMapping)
                Spacer(minLength: 10)
            }
            
            printCell(key: "Building:", value: self.room.buildingName)
            printCell(key: "Building Number:", value: String(self.room.buildingNumber))
            printCell(key: "Building Code:", value: self.room.buildingCode)
            if let id = self.room.raum_nr_architekt {
                printCell(key: "ID:", value: id)
            }
            if let attributes = self.room.attributes, attributes.count > 0 {
                Text("Attributes:")
                    .foregroundColor(Color(UIColor.darkGray))
                ForEach(attributes, id: \.name) { attribute in
                    HStack {
                        Spacer()
                        Text("\(attribute.name ?? "") \(attribute.detail ?? "")")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
            Spacer()
        }.padding([.trailing], 15)
    }
}
