//
//  ContactView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 30.12.22.
//

import SwiftUI

struct ContactView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        Group {
            if let profile = self.viewModel.profile,
               let profileImage = self.viewModel.profileImage {
                if profile.firstname != nil {
                    Text("Hi, " + profile.firstname!).font(.largeTitle).bold().frame(width: 350, height: 50, alignment: .leading)
                } else {
                    Text("Welcome").font(.largeTitle).bold().frame(width: 350, height: 50, alignment: .leading)
                }
                HStack {
                    profileImage
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .foregroundColor(Color(.secondaryLabel))
                    
                    VStack(alignment: .leading) {
                        Text(profile.fullName)
                            .font(.title2)
                        Text(profile.tumID!)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 6)
                .frame(width: UIScreen.main.bounds.size.width * 0.9)
                .background(Color.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
                .padding(.bottom)
            } else {
                ProgressView()
            }
        }.task {
            viewModel.fetch()
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
