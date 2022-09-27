//
//  TuitionView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.02.22.
//

import SwiftUI

struct TuitionView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        List {
            VStack(alignment: .center) {
                Spacer(minLength: 0.10 * UIScreen.main.bounds.width)
                TuitionCard(tuition: self.viewModel.tuition ?? Tuition(deadline: Date(), semester: "Unknown", semesterID: "0", amount: 0))
            }
            .listRowBackground(Color(.systemGroupedBackground))
        }
        .refreshable {
            self.viewModel.checkTuitionFunc()
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
