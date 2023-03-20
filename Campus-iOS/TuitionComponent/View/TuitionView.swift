//
//  TuitionView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.02.22.
//

import SwiftUI

struct TuitionView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var data = AppUsageData()
    
    var body: some View {
        if #available(iOS 16.0, *) {
            List {
                VStack(alignment: .center) {
                    Spacer(minLength: 0.10 * UIScreen.main.bounds.width)
                    TuitionCard(tuition: self.viewModel.tuition ?? Tuition.unknown)
                }
                .listRowBackground(Color.primaryBackground)
            }
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
            .refreshable {
                self.viewModel.checkTuitionFunc()
            }
            .task {
                data.visitView(view: .tuition)
            }
            .onDisappear {
                data.didExitView()
            }
        } else {
            Text("This content is only available on iOS 16 or higher 🫠").padding(.horizontal)
        }
    }
}

struct TuitionView_Previews: PreviewProvider {
    
    static var previews: some View {
        TuitionView(viewModel: ProfileViewModel())
        TuitionView(viewModel: ProfileViewModel())
            .preferredColorScheme(.dark)
    }
}
