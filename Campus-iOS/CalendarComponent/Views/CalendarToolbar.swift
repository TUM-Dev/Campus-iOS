//
//  CalendarToolbar.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import SwiftUI

struct CalendarToolbar: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    @Binding var selectedEventID: String?
    @Binding var isTodayPressed: Bool
    
    var body: some View {
        HStack() {
            NavigationLink(destination:
                VStack{
                    GeometryReader { geo in
                        CalendarDisplayView(events: viewModel.events.map({ $0.kvkEvent }), type: .list, selectedEventID: self.$selectedEventID, frame: CalendarContentView.getSafeAreaFrame(geometry: geo), todayPressed: self.$isTodayPressed, calendarWeekDays: 7)
                        .navigationBarTitle(Text("Events"))
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        ProfileToolbar(model: self.viewModel.model)
                    }
                }
            ) {
                Label("", systemImage: "list.bullet")
            }

            Spacer().frame(width: 15)
            Button(action: { self.isTodayPressed = true }) {
                Text("Today")
            }
        }
    }
}

struct CalendarToolbar_Previews: PreviewProvider {
    
    @State static var selectedEventId: String? = "test123"
    @State static var todayPressed = false
    static var model = MockModel()
    
    static var previews: some View {
        CalendarToolbar(viewModel: CalendarViewModel(model: model), selectedEventID: $selectedEventId, isTodayPressed: $todayPressed)
    }
}
