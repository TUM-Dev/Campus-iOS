//
//  PersonSearchListView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct PersonSearchListView: View {
    
    @Environment(\.isSearching) private var isSearching
    @ObservedObject var viewModel: PersonSearchViewModel
    
    var body: some View {
        List {
            ForEach(self.viewModel.result, id: \.nr) { person in
                NavigationLink(
                    destination: PersonDetailedView(withPerson: person)
                                    .navigationBarTitleDisplayMode(.inline)
                ) {
                    Text(person.fullName)
                }
            }
            if viewModel.errorMessage != "" {
                VStack {
                    Spacer()
                    Text(self.viewModel.errorMessage).foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .onChange(of: isSearching) { newValue in
            if !newValue {
                self.viewModel.result = []
            }
        }
    }
}

struct PersonSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonSearchListView(viewModel: PersonSearchViewModel())
    }
}
