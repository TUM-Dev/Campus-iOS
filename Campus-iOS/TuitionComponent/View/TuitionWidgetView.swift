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
        VStack (alignment: .leading) {
            if let tuition = self.viewModel.tuition {
                OpenTuitionAmountView(tuition: tuition)
                HStack {
                    Text("Deadline")
                    
                    if let date = tuition.deadline {
                        Text(date, style: .date)
                    } else {
                        Text("Unknown")
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task {
            viewModel.fetch()
        }
    }
}

struct TuitionWidgetView_Previews: PreviewProvider {
    
    static let content = WidgetView(
        size: .rectangle,
        title: "Tuition Fee",
        content: TuitionWidgetView(viewModel: ProfileViewModel())
    )
    
    static var previews: some View {
        content
        content
            .preferredColorScheme(.dark)
    }
}
