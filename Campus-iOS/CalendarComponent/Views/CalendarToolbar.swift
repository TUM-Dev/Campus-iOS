//
//  CalendarToolbar.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 23.12.21.
//

import SwiftUI

struct CalendarToolbar: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        HStack() {
            Button(action: {viewModel.showEventsList.toggle()}) {
                Image(systemName: "list.bullet")
            }
            .sheet(isPresented: $viewModel.showEventsList) {
                ProfileView()
                    .environmentObject(viewModel)
            }
            Spacer().frame(width: 15)
            Button(action: {}) {
                Text("Today")
            }
        }
    }
}

struct CalendarToolbar_Previews: PreviewProvider {
    static var previews: some View {
        CalendarToolbar(viewModel: CalendarViewModel())
    }
}
