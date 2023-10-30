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
