//
//  StudyRoomGroupView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import SwiftUI

struct StudyRoomGroupView: View {
    @StateObject var vm: MapViewModel
    
    @Binding var selectedGroup: StudyRoomGroup?
    @State var rooms: [StudyRoom]
    @State private var data = AppUsageData()
    private let canDismiss: Bool
    @Binding var panelHeight: CGFloat
    let dragAreaHeight = PanelHeight.top * 0.04
    
    init(vm: MapViewModel, selectedGroup: Binding<StudyRoomGroup?>, rooms: [StudyRoom], panelHeight: Binding<CGFloat> = .constant(0), canDismiss: Bool = true) {
        self._vm = StateObject(wrappedValue: vm)
        self._selectedGroup = selectedGroup
        self._rooms = State(initialValue: rooms)
        self._data = State(initialValue: AppUsageData())
        self._panelHeight = panelHeight
        self.canDismiss = canDismiss
    }

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
        Group {
            if let group = selectedGroup {
                VStack {
                    VStack(spacing: 1) {
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
                            .onTapGesture { }
                            .gesture(panelDragGesture)
                            
                            Spacer()
                            
                            if (canDismiss) {
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
                        }
                        .onTapGesture { }
                        .gesture(panelDragGesture)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                let latitude = group.coordinate?.latitude
                                let longitude = group.coordinate?.longitude
                                let url = URL(string: "maps://?saddr=&daddr=\(latitude!),\(longitude!)")
                                
                                #if !WIDGET_TARGET
                                if UIApplication.shared.canOpenURL(url!) {
                                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                }
                                #endif
                            }, label: {
                                Text("Show Directions \(Image(systemName: "arrow.right.circle"))")
                                    .foregroundColor(.blue)
                                    .font(.footnote)
                            })
                        }
                        .onTapGesture { }
                        .gesture(panelDragGesture)
                    }
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                    
                    ZStack {
                        Color(UIColor.secondarySystemBackground)
                        
                        List {
                            ForEach(self.sortedRooms, id: \.id) { room in
                                DisclosureGroup(content: {
                                    StudyRoomDetailsView(studyRoom: room)
                                }, label: {
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
                                            
                                            room.localizedStatusText
                                        }
                                    )
                                })
                                .accentColor(Color(UIColor.lightGray))
                            }
                        }
                        .listStyle(.plain)
                        .cornerRadius(10.0)
                        .padding()
                    }
                }
                
            } else {
                Text("No Study Room Data available")
            }
        }
        .task {
            data.visitView(view: .studyRoom)
        }
        .onDisappear {
            data.didExitView()
        }
    }
    
    var panelDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard !vm.lockPanel else { return }
                panelHeight = panelHeight - value.translation.height
            }
            .onEnded { _ in
                withAnimation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)) {
                    snapPanel(from: panelHeight)
                }
            }
    }
    
    func snapPanel(from height: CGFloat) {
        let snapHeights = [PanelPos.top, PanelPos.middle, PanelPos.bottom]
        
        vm.panelPos = closestMatch(values: snapHeights, inputValue: height)
        panelHeight = vm.panelPos.rawValue
    }
    
    func closestMatch(values: [PanelPos], inputValue: CGFloat) -> PanelPos {
        return (values.reduce(values[0]) { abs($0.rawValue-inputValue) < abs($1.rawValue-inputValue) ? $0 : $1 })
    }
}

struct StudyRoomGroupView_Previews: PreviewProvider {
    @State static var ph: CGFloat = 0.0
    static var vm = MapViewModel(cafeteriaService: CafeteriasService(), studyRoomsService: StudyRoomsService(), mock: true)
    
    static var previews: some View {

        StudyRoomGroupView(vm: vm, selectedGroup: .constant(StudyRoomGroup()), rooms: [StudyRoom(room: FoundRoom(roomId: "1", roomCode: "1", buildingNumber: "1", id: "1", info: "TestRoom1", address: "Garching", purpose: "Lectures", campus: "Garching", name: "TestRoom1")), StudyRoom(room: FoundRoom(roomId: "2", roomCode: "2", buildingNumber: "2", id: "2", info: "TestRoom2", address: "Garching", purpose: "Lectures", campus: "Garching", name: "TestRoom2")), StudyRoom(room: FoundRoom(roomId: "3", roomCode: "3", buildingNumber: "3", id: "3", info: "TestRoom3", address: "Garching", purpose: "Lectures", campus: "Garching", name: "TestRoom3"))], panelHeight: $ph)
        
    }
}
