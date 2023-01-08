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
        NavigationLink(destination: TuitionView(viewModel: self.profileViewModel).navigationBarTitle(Text("Tuition fees"))) {
            Label {
                HStack {
                    Text("Tuition fees").foregroundColor(Color.primaryText)
                    if let isOpenAmount = profileViewModel.tuition?.isOpenAmount, isOpenAmount != true {
                        Spacer()
                        Text("✅")
                    } else {
                        Spacer()
                        Text(self.formattedAmount).foregroundColor(.red)
                    }
                    Image(systemName: "chevron.right").foregroundColor(Color.primaryText)
                }
            } icon: {
                Image(systemName: "eurosign.circle").foregroundColor(Color.primaryText)
            }
            .padding(.vertical, 15)
            .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.size.width * 0.9)
        .background(Color.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
    }
}
