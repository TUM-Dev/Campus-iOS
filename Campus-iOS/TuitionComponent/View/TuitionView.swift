//
//  TuitionView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.02.22.
//

import SwiftUI

struct TuitionView: View {
    
    let tuition: Tuition
    @State private var data = AppUsageData()
    
    var body: some View {
        List {
            VStack(alignment: .center) {
                Spacer(minLength: 0.10 * UIScreen.main.bounds.width)
                TuitionCard(tuition: self.tuition)
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
        .task {
            data.visitView(view: .tuition)
        }
        .onDisappear {
            data.didExitView()
        }
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
