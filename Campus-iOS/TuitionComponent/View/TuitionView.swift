//
//  TuitionView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.02.22.
//

import SwiftUI

struct TuitionView: View {
    
    let tuition: Tuition
    
    var body: some View {
        List {
            VStack(alignment: .center) {
                Spacer(minLength: 0.10 * UIScreen.main.bounds.width)
                TuitionCard(tuition: self.tuition)
            }
            .listRowBackground(Color.primaryBackground)
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
    }
}

//struct TuitionView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        TuitionView(viewModel: ProfileViewModel())
//        TuitionView(viewModel: ProfileViewModel())
//            .preferredColorScheme(.dark)
//    }
//}
