//
//  TuitionViewNEW.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 07.01.23.
//

import SwiftUI

struct TuitionViewNEW: View {
    
    @StateObject var profileViewModel: ProfileViewModel
    
    var formattedAmount: String {
        guard let amount = self.profileViewModel.tuition?.amount else {
            return "n/a"
        }
        return OpenTuitionAmountView.currencyFormatter.string(from: amount) ?? "n/a"
    }
    
    var body: some View {
        Group {
            switch profileViewModel.tuitionState {
            case .success(let tuition):
                NavigationLink(destination: TuitionView(tuition: tuition).navigationBarTitle(Text("Tuition fees"))) {
                    Label {
                        HStack {
                            Text("Tuition fees").foregroundColor(Color.primaryText)
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
                            Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                        }
                    } icon: {
                        Image(systemName: "eurosign.circle").foregroundColor(Color.primaryText)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal)
                }
                .frame(width: Size.cardWidth)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
            case .loading, .na:
                Text("Loading")
            case .failed(error: let error):
                Text(error.localizedDescription)
            }
        }
        .task {
            await profileViewModel.getTuition(forcedRefresh: true)
        }
    }
}
