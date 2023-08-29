//
//  HomeView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 28.12.22.
//

import SwiftUI

@available(iOS 16.0, *)
struct HomeScreen: View {
    
    @StateObject var model: Model
    @StateObject var profileVm: ProfileViewModel //profile info
    
    init (model: Model) {
        self._model = StateObject(wrappedValue: model)
        self._profileVm = StateObject(wrappedValue: ProfileViewModel(model: model, service: ProfileService()))
    }
    
    var body: some View {
        Group{
            switch profileVm.profileState {
            case .success(let profile):
                ScrollView {
                    ContactScreen(model: self.model, profileVm: self.profileVm, profile: profile)
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                    Divider()
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    WidgetScreen(model: self.model)
                }
            case .loading, .na:
                LoadingView(text: "Fetching Profile")
            case .failed(error: let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: profileVm.getProfile
                )
            }
        }
        .padding(.top, 50)
        .background(Color.primaryBackground)
        .task {
            await profileVm.getProfile(forcedRefresh: true)
        }
        .alert(
            "Error while fetching Profile",
            isPresented: $profileVm.profileHasError,
            presenting: profileVm.profileState) { detail in
                Button("Retry") {
                    Task {
                        await profileVm.getProfile(forcedRefresh: true)
                    }
                }
        
                Button("Cancel", role: .cancel) { }
            } message: { detail in
                if case let .failed(error) = detail {
                    if let apiError = error as? TUMOnlineAPIError {
                        Text(apiError.errorDescription ?? "TUMOnlineAPI Error")
                    } else {
                        Text(error.localizedDescription)
                    }
                }
            }
    }
}
