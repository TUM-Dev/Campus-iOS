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
            ForEach(vm.searchDataTypeResult, id:\.0) { (key,value) in
                if let accuracy = value {
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
                        NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .news), query: $query)
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
                    case .Movie:
                        NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .movie), query: $query)
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 10)
                            
                    }
                }
                RoomFinderSearchResultView(query: $query)
                LectureSearchResultView(vm: LectureSearchResultViewModel(model: vm.model), query: $query)
                PersonSearchResultView(vm: PersonSearchResultViewModel(model: vm.model), query: $query)
            }
            Spacer()
        }.onChange(of: query) { newQuery in
            vm.search(for: newQuery)
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(vm: SearchResultViewModel(model: Model()), query: .constant("hello world"))
    }
}
