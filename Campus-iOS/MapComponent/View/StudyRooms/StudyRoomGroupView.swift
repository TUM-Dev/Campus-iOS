//
//  StudyRoomGroupView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import SwiftUI

struct StudyRoomGroupView: View {
    @Binding var selectedGroup: StudyRoomGroup?
    @State var rooms: [StudyRoom]
    
    var sortedRooms: [StudyRoom] {
        self.rooms.sorted(by: { (lhs, rhs) -> Bool in
            if lhs.status==rhs.status{
                return true
            } else if lhs.status == "frei" {
                return true
            } else if lhs.status == "belegt" {
                if rhs.status == "frei" {
                    return false
                } else {
                    return true
                }
            }
            return false
        })
    }
    
    var body: some View {
        if let group = selectedGroup {
            VStack {
                HStack{
                    VStack(alignment: .leading){
                        Text(group.name ?? "")
                            .bold()
                            .font(.title3)
                        if let detail = group.detail {
                            Text(detail)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                    }
                    
                    Spacer()

                    Button(action: {
                        selectedGroup = nil
                    }, label: {
                        Text("Done")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                                .padding(.all, 5)
                                .background(Color.clear)
                                .accessibility(label:Text("Close"))
                                .accessibility(hint:Text("Tap to close the screen"))
                                .accessibility(addTraits: .isButton)
                                .accessibility(removeTraits: .isImage)
                        })
                }
                .padding(.trailing, 20)
                .padding(.leading, 20)
                .padding(.top, 5)
                .padding(.bottom, 10)
                
                List {
                    ForEach(self.sortedRooms, id: \.id) { room in
                        Collapsible(title: {
                            AnyView(
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(room.name ?? "")
                                            .fontWeight(.bold)
                                        HStack {
                                            Image(systemName: "barcode.viewfinder")
                                                .frame(width: 12, height: 12)
                                                .foregroundColor(Color("tumBlue"))
                                            Text(room.code ?? "")
                                                .font(.system(size: 12))
                                            Spacer()
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .foregroundColor(.init(.darkGray))
                                        .padding(.leading, 5)
                                        .padding(.trailing, 5)
                                        .padding(.top, 0)
                                        .padding(.bottom, 0)
                                    }
                                    
                                    Spacer()
                                    
                                    room.localizedStatus
                                }
                            )
                        }, content: {
                            StudyRoomDetailsView(studyRoom: room)
                        }, applyPadding: false)
                    }
                }
            }
        }
    }
}

struct StudyRoomGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomGroupView(selectedGroup: .constant(StudyRoomGroup()), rooms: [StudyRoom]())
    }
}
