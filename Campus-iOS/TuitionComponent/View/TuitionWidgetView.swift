//
//  TuitionWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct TuitionWidgetView: View {
    
    let size: WidgetSize
    
    var body: some View {
        WidgetView(size: size, content: TuitionWidgetContentView())
    }
}

struct TuitionWidgetContentView: View {
    @StateObject var viewModel = ProfileViewModel()

    var body: some View {
        VStack (alignment: .leading) {
            
            WidgetTitleView(title: "Tuition Fee")
                .padding(.bottom, 2)
            
            if let tuition = self.viewModel.tuition {
                VStack(alignment: .leading) {
                    OpenTuitionAmountView(tuition: tuition)
                    Text("Open Amount")
                        .font(.caption)
                        .padding(.bottom)
                    
                    HStack {
                        Text("Deadline")
                        if let date = tuition.deadline {
                            Text(date, style: .date)
                        } else {
                            Text("Unknown")
                        }
                    }
                }
            } else {
                ProgressView()
            }
            
            Spacer()
        }
        .task {
            viewModel.fetch()
        }
    }
}

struct TuitionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TuitionWidgetView(size: .rectangle)
        TuitionWidgetView(size: .rectangle)
            .preferredColorScheme(.dark)
    }
}
