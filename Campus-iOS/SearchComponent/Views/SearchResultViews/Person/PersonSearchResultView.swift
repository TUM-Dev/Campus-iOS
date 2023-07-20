//
//  PersonSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 14.01.23.
//

import SwiftUI

struct PersonSearchResultView: View {
    let allResults: [Person]
    let model: Model
    @State var size: ResultSize = .small
    
    var results: [Person] {
        switch size {
        case .small:
            return Array(allResults.prefix(3))
        case .big:
            return allResults
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
                    ZStack {
                        Text("Person Search")
                            .fontWeight(.bold)
                            .font(.title)
                        ExpandIcon(size: $size)
                    }
                }
                ScrollView {
                    ForEach(results, id: \.id) { result in
                        VStack(alignment: .leading) {
                            NavigationLink(
                                destination: PersonDetailedScreenSearch(model: model, person: result)
                                    .navigationBarTitleDisplayMode(.inline)
                            ) {
                                HStack {
                                    Text(result.fullName)
                                    Spacer()
                                    Image(systemName: "info.circle")
                                        .foregroundColor(Color.highlightText)
                                }
                            }.buttonStyle(.plain)
                            Divider()
                        }
                    }
                }
            }.padding()
        }
    }
}
