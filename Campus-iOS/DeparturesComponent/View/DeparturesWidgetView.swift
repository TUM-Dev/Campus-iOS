//
//  DeparturesWidgetView.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import SwiftUI

struct DeparturesWidgetView: View {
    
    @StateObject var departuresViewModel: DepaturesWidgetViewModel
    @State var showDetailsSheet = false
    
    init() {
        self._departuresViewModel = StateObject(wrappedValue: DepaturesWidgetViewModel())
    }
    
    var body: some View {
        Text("This will be the widget view?")
            .onAppear {
                departuresViewModel.timer = Timer()
                departuresViewModel.setTimerForRefetch()
            }
            .onDisappear {
                if !showDetailsSheet {
                    departuresViewModel.timer?.invalidate()
                }
            }
        Button("Show Details", action: {
            showDetailsSheet = true
        })
        .sheet(isPresented: $showDetailsSheet, content: {
            DeparturesDetailsView(departuresViewModel: departuresViewModel)
        })
    }
}

struct DeparturesWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesWidgetView()
    }
}
