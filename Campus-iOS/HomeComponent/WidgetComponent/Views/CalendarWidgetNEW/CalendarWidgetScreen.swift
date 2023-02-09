//
//  CalendarWidgetScreen.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 19.01.23.
//

import SwiftUI

struct CalendarWidgetScreen: View {
    
    @StateObject var vm: CalendarViewModel
    
    var body: some View {
        switch self.vm.state {
        case .success(data: _):
            CalendarWidgetViewNEW(vm: self.vm)
        case .loading:
            ProgressView()
        case .failed(error: let error):
            Text("Error").onAppear{
                print(error)
            }
        case .na:
            Text("nothing")
        }
    }
}
