//
//  CalendarView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import SwiftUI
import KVKCalendar

struct CalendarContentView: View {
    @State var selectedType: TumCalendarTypes = .day
    
    @ObservedObject var model: Model
    @ObservedObject var viewModel: CalendarViewModel
    
    init(model: Model) {
        self.model = model
        self.viewModel = CalendarViewModel()
    }
    
    var body: some View {
        VStack{
            Picker("Calendar Type", selection: $selectedType) {
                ForEach(TumCalendarTypes.allCases, id: \.self) {
                    Text($0.localizedString)
                }
            }
            .pickerStyle(.segmented)
            switch self.selectedType {
            case .day:
                CalendarDisplayView(viewModel: self.viewModel, type: .day)
            case .month:
                CalendarDisplayView(viewModel: self.viewModel, type: .month)
            case .week:
                CalendarDisplayView(viewModel: self.viewModel, type: .week)
            }
        }
        .onChange(of: viewModel.lastSelectedEventId) { newValue in
            print("Arrived here with event id \(newValue)")
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                CalendarToolbar(viewModel: self.viewModel)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ProfileToolbar(model: model)
            }
        }
    }
}
struct CalendarContentView_Previews: PreviewProvider {
    
    static var model = MockModel()
    
    static var previews: some View {
        CalendarContentView(model: model)
    }
}
