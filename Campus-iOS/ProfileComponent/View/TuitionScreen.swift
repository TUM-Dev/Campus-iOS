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
                    .sectionStyle()
            }
        }.task {
            await vm.getTuition(forcedRefresh: true)
        }
    }
}

//struct ProfileMyTumSection: View {
//
//    @EnvironmentObject private var model: Model
//
//    var formattedAmount: String {
//        guard let amount = self.model.profile.tuition?.amount else {
//            return "n/a"
//        }
//        return OpenTuitionAmountView.currencyFormatter.string(from: amount) ?? "n/a"
//    }
//
//    var body: some View {
//        Section("MY TUM") {
////            NavigationLink(destination: TuitionView(viewModel: self.model.profile).navigationBarTitle(Text("Tuition fees"))) {
////                Label {
////                    HStack {
////                        Text("Tuition fees")
////                        if let isOpenAmount = self.model.profile.tuition?.isOpenAmount, isOpenAmount != true {
////                            Spacer()
////                            Text("✅")
////                        } else {
////                            Spacer()
////                            Text(self.formattedAmount).foregroundColor(.red)
////                        }
////                    }
////                } icon: {
////                    Image(systemName: "eurosign.circle")
////                }
////            }
////            .disabled(!self.model.isUserAuthenticated)
//
//            NavigationLink(destination: PersonSearchScreen(model: self.model).navigationBarTitle(Text("Person Search")).navigationBarTitleDisplayMode(.large)) {
//                Label("Person Search", systemImage: "magnifyingglass")
//            }
//            .disabled(!self.model.isUserAuthenticated)
//
//            NavigationLink(destination: LectureSearchScreen(model: model).navigationBarTitle(Text("Lecture Search")).navigationBarTitleDisplayMode(.large)) {
//                Label("Lecture Search", systemImage: "brain.head.profile")
//            }
//            .disabled(!self.model.isUserAuthenticated)
//        }
//    }
//}
//
//struct ProfileMyTumSection_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileMyTumSection()
//    }
//}
