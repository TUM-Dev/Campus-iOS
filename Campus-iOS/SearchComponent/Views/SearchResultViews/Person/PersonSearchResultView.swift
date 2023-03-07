//
//  PersonSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 14.01.23.
//

import SwiftUI

struct PersonSearchResultView: View {
    let allResults: [Person]
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
                        HStack {
                            Spacer()
                            Button {
                                switch size {
                                case .big:
                                    withAnimation {
                                        self.size = .small
                                    }
                                case .small:
                                    withAnimation {
                                        self.size = .big
                                    }
                                }
                            } label: {
                                if self.size == .small {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .padding()
                                } else {
                                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                                        .padding()
                                }
                            }
                        }
                    }
                }
                ScrollView {
                    ForEach(results, id: \.id) { result in
                        VStack(alignment: .leading) {
                            NavigationLink(
                                destination: PersonDetailedView(withPerson: result)
                                    .navigationBarTitleDisplayMode(.inline)
                            ) {
                                HStack {
                                    Text(result.fullName)
                                    Spacer()
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.tumBlue)
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
