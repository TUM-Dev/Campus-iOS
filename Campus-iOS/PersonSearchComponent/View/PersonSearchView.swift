//
//  PersonSearchListView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct PersonSearchView: View {
    let persons: [Person]
    
    var body: some View {
        List {
            ForEach(self.persons, id: \.nr) { person in
                NavigationLink(
                    destination: PersonDetailedView(withPerson: person)
                                    .navigationBarTitleDisplayMode(.inline)
                ) {
                    Text(person.fullName)
                }
            }
        }
    }
}

struct PersonSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PersonSearchView(persons: [])
    }
}
