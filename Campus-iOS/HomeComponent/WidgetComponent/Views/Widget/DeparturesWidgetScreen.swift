//
//  DeparturesWidgetScreen.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 01.03.23.
//

import SwiftUI

struct DeparturesWidgetScreen: View {
    
    @StateObject var departuresViewModel: DeparturesWidgetViewModel
    @State var showDetailsSheet = false
    
    var body: some View {
        Group {
            switch(self.departuresViewModel.state) {
            case .success, .failed, .loading:
                DeparturesWidgetView(departuresViewModel: departuresViewModel, showDetailsSheet: $showDetailsSheet)
            case .noLocation:
                EmptyView()
            }
        }       
        .background(Color("primaryBackground"))
        .onAppear {
            departuresViewModel.timer = Timer()
            departuresViewModel.setTimerForRefetch()
        }
        .onDisappear {
            if !showDetailsSheet {
                departuresViewModel.timer?.invalidate()
            }
        }
        .onTapGesture {
            showDetailsSheet.toggle()
        }
    }
}

struct DeparturesWidgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesWidgetScreen(departuresViewModel: DeparturesWidgetViewModel())
    }
}
