//
//  SearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

enum ResultSize {
    case big
    case small
}

struct SearchResultView: View {
    @StateObject var vm: SearchResultViewModel
    @Binding var query: String
    private let preview = (ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1")
    
    var body: some View {
        GeometryReader { g in
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
                            if preview {
                                CafeteriasSearchResultView(vm: CafeteriasSearchResultViewModel(service: CafeteriasService_Preview()), query: $query)
                            } else {
                                CafeteriasSearchResultView(vm: CafeteriasSearchResultViewModel(service: CafeteriasService()), query: $query)
                            }
                            
                        case .News:
                            if preview {
                                NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .news, newsService: NewsService()), query: $query)
                            } else {
                                NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .news, newsService: NewsService()), query: $query)
                            }
                            
                        case .StudyRoom:
                            if preview {
                                StudyRoomSearchResultView(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService_Preview()), query: $query)
                            } else {
                                StudyRoomSearchResultView(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService()),query: $query)
                            }
                            
                        case .Calendar:
                            if preview {
                                EventSearchResultView(query: $query, vm: EventSearchResultViewModel(model: Model_Preview(), lecturesService: LecturesService_Preview(), calendarService: CalendarService_Preview()))
                            } else {
                                EventSearchResultView(query: $query, vm: EventSearchResultViewModel(model: self.vm.model, lecturesService: LecturesService(), calendarService: CalendarService()))
                            }
                            
                        case .Movie:
                            if preview {
                                NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .movie, movieService: MovieService_Preview()), query: $query)
                            } else {
                                NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .movie, movieService: MovieService()), query: $query)
                            }
                        }
                    }
                    .cornerRadius(25)
                    .padding()
                    .shadow(color: .gray.opacity(0.8), radius: 5)
                    Group {
                        RoomFinderSearchResultView(query: $query)
                        LectureSearchResultView(vm: LectureSearchResultViewModel(model: vm.model), query: $query)
                        PersonSearchResultView(vm: PersonSearchResultViewModel(model: vm.model), query: $query)
                    }
                    .cornerRadius(25)
                    .padding()
                    .shadow(color: .gray.opacity(0.8), radius: 10)
                }
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
        SearchResultView(vm: SearchResultViewModel(model: Model_Preview()), query: .constant("Movie "))
    }
}
