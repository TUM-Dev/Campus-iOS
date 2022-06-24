//
//  TuitionWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct TuitionWidgetView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            Text("Tuition Fee")
            TuitionDetailsView(tuition: self.viewModel.tuition ?? Tuition.unknown)
        }
    }
}

struct TuitionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(content: TuitionWidgetView(viewModel: ProfileViewModel()))
        WidgetView(content: TuitionWidgetView(viewModel: ProfileViewModel()))
            .preferredColorScheme(.dark)
    }
}
