//
//  PersonSearchView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 06.02.22.
//

import SwiftUI

struct PersonSearchScreen: View {
    @StateObject var vm: PersonSearchViewModel
    @State var searchText = ""
    var findPerson = ""
    
    init(model: Model) {
        self._vm = StateObject(wrappedValue: PersonSearchViewModel(model: model, service: PersonSearchService()))
    }
    
    init(model: Model, findPerson: String) {
        self._vm = StateObject(wrappedValue: PersonSearchViewModel(model: model, service: PersonSearchService()))
        self._searchText = State(wrappedValue: findPerson)
    }
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let persons):
                VStack {
                    PersonSearchView(persons: persons)
                        .background(Color(.systemGroupedBackground))
                }
            case .loading:
                LoadingView(text: "Fetching Persons")
            case .failed(let error):
                FailedView(
                    errorDescription: error.localizedDescription,
                    retryClosure: {_ in await vm.getPersons(for: self.searchText, forcedRefresh: true)}
                )
            case .na:
                EmptyView()
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: self.searchText) { query in
            Task {
                await vm.getPersons(for: query, forcedRefresh: true)
            }
        }
        .onAppear {
            if !searchText.isEmpty {
                Task {
                    await vm.getPersons(for: searchText, forcedRefresh: true)
                }
            }
        }
        .alert(
            "Error while fetching Persons",
            isPresented: $vm.hasError,
            presenting: vm.state) { detail in
                Button("Retry") {
                    Task {
                        await vm.getPersons(for: self.searchText, forcedRefresh: true)
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
