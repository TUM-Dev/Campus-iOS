//
//  PersonSearchView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 06.02.22.
//

import SwiftUI

struct PersonSearchView: View {
    
    @ObservedObject var viewModel = PersonSearchViewModel()
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            List(self.viewModel.result, id: \.nr) { person in
                NavigationLink(destination: PersonDetailedView(withPerson: person)) {
                    Text("\(person.firstName) \(person.name)")
                }
            }
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText)
        .onChange(of: self.searchText) { searchValue in
            if(searchValue.count > 3) {
                self.viewModel.fetch(searchString: searchValue)
            }
        }
    }
}

struct PersonSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PersonSearchView()
    }
}
