//
//  ProfileTuitionNavigationLink.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct TuitionScreen: View {
    
    @StateObject var vm: ProfileViewModel
    
    var body: some View {
        Group {
            switch vm.tuitionState {
            case .success(let tuition):
                NavigationLink(destination: TuitionView(tuition: tuition).navigationBarTitle(Text("Tuition fees"))) {
                    Label {
                        HStack {
                            Text("Tuition fees")
                            if !tuition.isOpenAmount {
                                Spacer()
                                Text("✅")
                            } else {
                                if let amount = tuition.amount, let formattedAmount = OpenTuitionAmountView.currencyFormatter.string(from: amount) {
                                    Spacer()
                                    Text(formattedAmount).foregroundColor(.red)
                                } else {
                                    Text("Open amount couldn't be fetched.")
                                }
                            }
                        }
                    } icon: {
                        Image(systemName: "eurosign.circle")
                    }
                }
            case .loading, .na:
                Text("Loading")
            case .failed(error: let error):
                Text(error.localizedDescription)
            }
        }.task {
            await vm.getTuition(forcedRefresh: true)
        }
    }
}
