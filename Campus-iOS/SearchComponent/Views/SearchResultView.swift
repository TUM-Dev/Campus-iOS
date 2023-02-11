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
    private let preview = (ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1")
    
    var body: some View {
        VStack {
            Text("Your results for: \(query)")
            Spacer()
            ForEach(vm.searchDataTypeResult, id:\.0) { (key,value) in
                if let accuracy = value {
                    Text("\(key) with accuracy of \(Int(accuracy*100)) %.")
                }
            }
            Spacer()
            ScrollView {
                ForEach(vm.orderedTypes, id: \.rawValue) { type in
                    switch type {
                    case .Grade:
                        if preview {
                            GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model, service: GradeService_Preview()), query: $query)
                        } else {
                            GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model, service: GradesService()), query: $query)
                        }
                    case .Cafeteria:
                        CafeteriasSearchResultView(query: $query)
                        
                    case .News:
                        NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .news), query: $query)
                        
                    case .StudyRoom:
                        StudyRoomSearchResultView(query: $query)
                        
                    case .Calendar:
                        EventSearchResultView(query: $query, vm: EventSearchResultViewModel(model: self.vm.model))
                        
                    case .Movie:
                        NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .movie), query: $query)
                    }
                }
                .cornerRadius(25)
                .padding()
                .shadow(color: .gray.opacity(0.8), radius: 10)
                Group {
                    RoomFinderSearchResultView(query: $query)
                    LectureSearchResultView(vm: LectureSearchResultViewModel(model: vm.model), query: $query)
                    PersonSearchResultView(vm: PersonSearchResultViewModel(model: vm.model), query: $query)
                }.cornerRadius(25)
                    .padding()
                    .shadow(color: .gray.opacity(0.8), radius: 10)
            }
        }.onChange(of: query) { newQuery in
            vm.search(for: newQuery)
        }
        .onAppear {
            vm.search(for: query)
        }
        
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(vm: SearchResultViewModel(model: Model_Preview()), query: .constant(" Grade Grundlagen"))
    }
}
