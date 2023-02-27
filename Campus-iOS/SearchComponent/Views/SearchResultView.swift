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
    @State var selectedType: BarType = BarType.all
    
    var body: some View {
        GeometryReader { g in
            VStack {
                SearchResultBarView(selectedType: $selectedType).frame(height: g.size.height/20).padding()
                //                Text("Your results for: \(query)")
                //                Spacer()
                //                ForEach(vm.searchDataTypeResult, id:\.0) { (key,value) in
                //                    if let accuracy = value {
                //                        Text("\(key) with accuracy of \(Int(accuracy*100)) %.")
                //                    }
                //                }
                //                Spacer()
                switch self.selectedType {
                case .grade:
                    ScrollView {
                        Group {
                            if preview {
                                GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model, service: GradeService_Preview()), query: $query, size: .big)
                            } else {
                                GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model, service: GradesService()), query: $query, size: .big)
                            }
                        }.cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                case .cafeteria:
                    ScrollView {
                        Group {
                            if preview {
                                CafeteriasSearchResultView(vm: CafeteriasSearchResultViewModel(service: CafeteriasService_Preview()), query: $query, size: .big)
                            } else {
                                CafeteriasSearchResultView(vm: CafeteriasSearchResultViewModel(service: CafeteriasService()), query: $query, size: .big)
                            }
                        }.cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                case .news:
                    ScrollView {
                        Group {
                            if preview {
                                NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .news, newsService: NewsService()), query: $query, size: .big)
                            } else {
                                NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .news, newsService: NewsService()), query: $query, size: .big)
                            }
                        }.cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                    
                case .studyRoom:
                    ScrollView {
                        Group {
                            if preview {
                                StudyRoomSearchResultView(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService_Preview()), query: $query, size: .big)
                            } else {
                                StudyRoomSearchResultView(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService()),query: $query, size: .big)
                            }
                        }.cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                    
                case .calendar:
                    ScrollView {
                        Group {
                            if preview {
                                EventSearchResultView(query: $query, vm: EventSearchResultViewModel(model: Model_Preview(), lecturesService: LecturesService_Preview(), calendarService: CalendarService_Preview()), size: .big)
                            } else {
                                EventSearchResultView(query: $query, vm: EventSearchResultViewModel(model: self.vm.model, lecturesService: LecturesService(), calendarService: CalendarService()), size: .big)
                            }
                        }.cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                    
                case .movie:
                    ScrollView {
                        Group {
                            if preview {
                                NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .movie, movieService: MovieService_Preview()), query: $query, size: .big)
                            } else {
                                NewsSearchResultView(vm: NewsSearchResultViewModel(vmType: .movie, movieService: MovieService()), query: $query, size: .big)
                            }
                        }.cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                case .roomFinder:
                    ScrollView {
                        RoomFinderSearchResultView(query: $query)
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                case .lectureSearch:
                    ScrollView {
                        LectureSearchResultView(vm: LectureSearchResultViewModel(model: vm.model), query: $query, size: .big)
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                case .personSearch:
                    ScrollView {
                        PersonSearchResultView(vm: PersonSearchResultViewModel(model: vm.model), query: $query, size: .big)
                            .cornerRadius(25)
                            .padding()
                            .shadow(color: .gray.opacity(0.8), radius: 5)
                    }
                case .all:
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
                    Spacer(minLength: 20)
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
