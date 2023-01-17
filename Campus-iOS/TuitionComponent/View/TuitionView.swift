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
        List {
            VStack(alignment: .center) {
                Spacer(minLength: 0.10 * UIScreen.main.bounds.width)
                TuitionCard(tuition: self.viewModel.tuition ?? Tuition.unknown)
            }
            .listRowBackground(Color(.systemGroupedBackground))
        }
        .refreshable {
            self.viewModel.checkTuitionFunc()
        }
        .onDisappear {
            data.didExitView()
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
