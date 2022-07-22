//
//  StudyRoomDetailsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 14.05.22.
//

import SwiftUI

struct StudyRoomDetailsView: View {
    
    @ObservedObject var viewModel: StudyRoomViewModel
    
    @State var showPopup = false
    
    init(studyRoom room: StudyRoom) {
        self.viewModel = StudyRoomViewModel(studyRoom: room)
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
            if viewModel.roomImageMapping.count > 0 {
                HStack {
                    Image(systemName: "map.fill").foregroundColor(.blue)
                    Text("Available Maps")
                        .fontWeight(.bold)
                        .font(.headline)
                }
                MapImagesHorizontalScrollingView(viewModel: viewModel)
                Spacer(minLength: 10)
            }
            
            printCell(key: "Building:", value: viewModel.room.buildingName)
            printCell(key: "Building Number:", value: String(viewModel.room.buildingNumber))
            printCell(key: "Building Code:", value: viewModel.room.buildingCode)
            if let id = viewModel.room.raum_nr_architekt {
                printCell(key: "ID:", value: id)
            }
            if let attributes = viewModel.room.attributes, attributes.count > 0 {
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

struct StudyRoomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomDetailsView(studyRoom: StudyRoom())
    }
}
