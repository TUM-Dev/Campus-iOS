//
//  StudyRoomGroupView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov and Timothy Summers on 05.05.22.
//

import SwiftUI

struct StudyRoomGroupView: View {
    @StateObject var vm: MapViewModel
    
    var selectedGroup: StudyRoomGroup?
    @State var rooms: [StudyRoom]
    @State private var data = AppUsageData()
    private let canDismiss: Bool
    @Binding var panelHeight: CGFloat
    let dragAreaHeight = PanelHeight.top * 0.04
    
    init(vm: MapViewModel, selectedGroup: StudyRoomGroup?, rooms: [StudyRoom], panelHeight: Binding<CGFloat> = .constant(0), canDismiss: Bool = true) {
        self._vm = StateObject(wrappedValue: vm)
        self.selectedGroup = selectedGroup
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
        ScrollView {
            if let group = selectedGroup {
                VStack {
                                        
                    LocationView(location: TUMLocation(studyRoomGroup: group))
                    
                    Text("Rooms").titleStyle()
                    
                    VStack {
                        ForEach(self.sortedRooms, id: \.id) { room in
                            DisclosureGroup(content: {
                                StudyRoomDetailsScreen(room: room)
                            }, label: {
                                AnyView(
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(room.name ?? "")
                                                .fontWeight(.bold)
                                                .multilineTextAlignment(.leading)
                                            HStack {
                                                Image(systemName: "numbersign")
                                                    .frame(width: 12, height: 12)
                                                    .foregroundColor(.highlightText)
                                                Text(room.code ?? "")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.highlightText)
                                                Spacer()
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        room.localizedStatusText
                                    }
                                )
                            })
                            .accentColor(.primaryText)
                            
                            if room.id != self.sortedRooms.last?.id {
                                Divider()
                            }
                        }
                    }
                    .sectionStyle()
                    .padding(.bottom)
                }
                
            } else {
                Text("No Study Room Data available")
            }
        }
        .background(Color.primaryBackground)
        .task {
            data.visitView(view: .studyRoom)
        }
        .onDisappear {
            data.didExitView()
        }
    }
    
    var panelDragGesture: some Gesture { //Legacy
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
    
    func snapPanel(from height: CGFloat) { //Legacy
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
        
        StudyRoomGroupView(vm: vm, selectedGroup: StudyRoomGroup(), rooms: [StudyRoom(room: FoundRoom(roomId: "1", roomCode: "1", buildingNumber: "1", id: "1", info: "TestRoom1", address: "Garching", purpose: "Lectures", campus: "Garching", name: "TestRoom1")), StudyRoom(room: FoundRoom(roomId: "2", roomCode: "2", buildingNumber: "2", id: "2", info: "TestRoom2", address: "Garching", purpose: "Lectures", campus: "Garching", name: "TestRoom2")), StudyRoom(room: FoundRoom(roomId: "3", roomCode: "3", buildingNumber: "3", id: "3", info: "TestRoom3", address: "Garching", purpose: "Lectures", campus: "Garching", name: "TestRoom3"))], panelHeight: $ph)
        
    }
}
