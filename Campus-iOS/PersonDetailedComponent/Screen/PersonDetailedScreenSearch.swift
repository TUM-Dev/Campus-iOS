//
//  PersonDetailedScreenSearch.swift
//  Campus-iOS
//
//  Created by David Lin on 21.01.23.
//

import SwiftUI

struct PersonDetailedScreenSearch: View {
    @StateObject var vm: PersonDetailedViewModel
    
    init(model: Model, person: Person) {
        self._vm = StateObject(wrappedValue: PersonDetailedViewModel(model: model, service: PersonDetailedService(), type: .Person(person)))
    }
    
    init(model: Model, profile: Profile) {
        self._vm = StateObject(wrappedValue: PersonDetailedViewModel(model: model, service: PersonDetailedService(), type: .Profile(profile)))
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let personDetails):
                VStack {
                    PersonDetailedView(personDetails: personDetails)
                        .background(Color(.systemGroupedBackground))
                }
            case .loading, .na:
                LoadingView(text: "Fetching Person Details")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: {_ in await vm.getDetails(forcedRefresh: true)}
                )
            }
        }
        .task {
            await vm.getDetails(forcedRefresh: true)
        }
        .alert("Error while fetching Person Details", isPresented: $vm.hasError, presenting: vm.state) { detail in
            Button("Retry") {
                Task {
                    await vm.getDetails(forcedRefresh: true)
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
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: AddToContactsView(contact: self.vm.cnContact)
                        .navigationBarTitleDisplayMode(.inline)
                ) {
                    Label("", systemImage: "person.crop.circle.badge.plus")
                }
            }
        }
    }
}
