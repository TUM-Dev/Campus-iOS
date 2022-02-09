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
        List {
            ForEach(self.viewModel.result, id: \.nr) { person in
                NavigationLink(destination: PersonDetailedView(withPerson: person)) {
                    Text(person.fullName)
                }
            }
            if(viewModel.errorMessage != "") {
                VStack {
                    Spacer()
                    Text(self.viewModel.errorMessage).foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: self.searchText) { searchValue in
            if(searchValue.count > 3) {
                self.viewModel.fetch(searchString: searchValue)
            }
        }
        .animation(.default, value: self.viewModel.result)
    }
}

struct PersonSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PersonSearchView()
    }
}
