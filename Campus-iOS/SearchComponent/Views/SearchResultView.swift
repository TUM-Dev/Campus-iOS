//
//  SearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct SearchResultView: View {
    @StateObject var vm: SearchResultViewModel
    @Binding var query: String
    
    var body: some View {
        VStack {
            Text("Your results for: \(query)")
            Spacer()
            ForEach(Array(vm.searchDataTypeResult.keys)) { key in
                if let accuracy = vm.searchDataTypeResult[key] {
                    Text("\(key) with accuracy of \(Int(accuracy*100)) %.")
                }
            }
            ScrollView {
                ForEach(vm.orderedTypes, id: \.rawValue) { type in
                    
                    switch type {
                    case .Grade:
                        GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model), query: $query)
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 10)
                    case .Cafeteria:
                        CafeteriasSearchResultView(query: $query)
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 10)
                    case .News:
                        NewsSearchResultView(query: $query)
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 10)
                    case .StudyRoom:
                        StudyRoomSearchResultView(query: $query)
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 10)
                    case .Calendar:
                        EventSearchResultView(query: $query, vm: EventSearchResultViewModel(model: self.vm.model))
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 10)
                            
                    }
                }
            }
            Spacer()
        }.onChange(of: query) { newQuery in
            Task {
                await vm.search(for: newQuery)
            }
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(vm: SearchResultViewModel(model: Model()), query: .constant("hello world"))
    }
}
