//
//  PersonDetailedScreenUser.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 17.04.23.
//

import SwiftUI

struct PersonDetailedScreenUser: View {
    
    @StateObject var personDetailedVm: PersonDetailedViewModel
    @StateObject var profileVm: ProfileViewModel
    @Binding var showProfileSheet: Bool
    var studyPrograms: [String]
    let profile: Profile
    
    
    init(model: Model, profileVm: ProfileViewModel, studyPrograms: [String], showProfileSheet: Binding<Bool>, profile: Profile) {
        self._personDetailedVm = StateObject(wrappedValue: PersonDetailedViewModel(model: model, service: PersonDetailedService(), type: .Profile(profile)))
        self.studyPrograms = studyPrograms
        self._showProfileSheet = showProfileSheet
        self._profileVm = StateObject(wrappedValue: profileVm)
        self.profile = profile
    }
    
    var body: some View {
        Group {
            switch personDetailedVm.state {
            case .success(let personDetails):
                VStack {
                    PersonDetailedViewUser(personDetails: personDetails, studyPrograms: self.studyPrograms, profileVm: self.profileVm, profile: self.profile, showProfileSheet: self.$showProfileSheet)
                }
            case .loading, .na:
                LoadingView(text: "Fetching Person Details")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: {_ in await personDetailedVm.getDetails(forcedRefresh: true)}
                )
            }
        }
        .task {
            await personDetailedVm.getDetails(forcedRefresh: true)
        }
        .alert("Error while fetching Person Details", isPresented: $personDetailedVm.hasError, presenting: personDetailedVm.state) { detail in
            Button("Retry") {
                Task {
                    await personDetailedVm.getDetails(forcedRefresh: true)
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
