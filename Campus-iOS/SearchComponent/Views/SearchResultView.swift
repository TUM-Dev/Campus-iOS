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
    @State private var query = ""
    private let preview = (ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1")
    @State var selectedType: BarType = BarType.all
    
    @State var recommondationQueries = ["Mensa Garching Menu", "StudyRoom Innenstadt free", "News TUM"]
    
    var body: some View {
        GeometryReader { g in
            if query.isEmpty {
                List {
                    Section("Recommended Queries") {
                        ForEach(recommondationQueries) { query in
                            Button {
                                withAnimation {
                                    self.query = query
                                }
                            } label: {
                                Text(query)
                                    .buttonStyle(.plain)
                                    .foregroundColor(.primaryText)
                            }
                        }
                        .listRowBackground(Color.secondaryBackground)
                    }
                }
                .scrollContentBackground(.hidden)
                
            } else {
                VStack {
                    SearchResultBarView(selectedType: $selectedType).frame(height: g.size.height/20).padding(.vertical)
                    /// **For debugging purposes**
                    //                Text("Your results for: \(query)")
                    //                Spacer()
                    //                ForEach(vm.searchDataTypeResult, id:\.0) { (key,value) in
                    //                    if let accuracy = value {
                    //                        Text("\(key) with accuracy of \(Int(accuracy*100)) %.")
                    //                    }
                    //                }
                    //                Spacer()
                    /// **For debugging purposes**
                    switch self.selectedType {
                    case .grade:
                        ScrollView (showsIndicators: false) {
                            Group {
                                if preview {
                                    GradesSearchResultScreen(vm: GradesSearchResultViewModel(model: vm.model, service: GradesService_Preview()), query: $query, size: .big)
                                } else {
                                    GradesSearchResultScreen(vm: GradesSearchResultViewModel(model: vm.model, service: GradesService()), query: $query, size: .big)
                                }
                            }.sectionStyle()
                                .padding(.bottom)
                        }
                    case .cafeteria:
                        ScrollView (showsIndicators: false) {
                            Group {
                                if preview {
                                    CafeteriaSearchResultScreen(vm: CafeteriaSearchResultViewModel(service: CafeteriasService_Preview()), query: $query, size: .big)
                                } else {
                                    CafeteriaSearchResultScreen(vm: CafeteriaSearchResultViewModel(service: CafeteriasService()), query: $query, size: .big)
                                }
                            }.sectionStyle()
                                .padding(.bottom)
                        }
                    case .news:
                        ScrollView (showsIndicators: false) {
                            Group {
                                if preview {
                                    NewsSearchResultScreen(vm: NewsSearchResultViewModel(service: NewsService_Preview()), query: $query, size: .big)
                                } else {
                                    NewsSearchResultScreen(vm: NewsSearchResultViewModel(service: NewsService()), query: $query, size: .big)
                                }
                            }.sectionStyle()
                                .padding(.bottom)
                        }
                        
                    case .studyRoom:
                        ScrollView (showsIndicators: false) {
                            Group {
                                if preview {
                                    StudyRoomSearchResultScreen(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService_Preview()), query: $query, size: .big)
                                } else {
                                    StudyRoomSearchResultScreen(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService()),query: $query, size: .big)
                                }
                            }.sectionStyle()
                                .padding(.bottom)
                        }
                        
                    case .calendar:
                        ScrollView (showsIndicators: false) {
                            Group {
                                if preview {
                                    EventSearchResultScreen(vm: EventSearchResultViewModel(model: Model_Preview(), lecturesService: LecturesService_Preview(), calendarService: CalendarService_Preview()), query: $query, size: .big)
                                } else {
                                    EventSearchResultScreen(vm: EventSearchResultViewModel(model: self.vm.model, lecturesService: LecturesService(), calendarService: CalendarService()), query: $query, size: .big)
                                }
                            }.sectionStyle()
                                .padding(.bottom)
                        }
                        
                    case .movie:
                        ScrollView (showsIndicators: false) {
                            Group {
                                if preview {
                                    MovieSearchResultScreen(vm: MovieSearchResultViewModel(service: MovieService_Preview()), query: $query, size: .big)
                                } else {
                                    MovieSearchResultScreen(vm: MovieSearchResultViewModel(service: MovieService()), query: $query, size: .big)
                                }
                            }.sectionStyle()
                                .padding(.bottom)
                        }
                    case .roomFinder:
                        ScrollView (showsIndicators: false) {
                            RoomFinderSearchResultScreen(vm: RoomFinderSearchResultViewModel(), query: $query)
                                .sectionStyle()
                                .padding(.bottom)
                        }
                    case .lectureSearch:
                        ScrollView (showsIndicators: false) {
                            LectureSearchResultScreen(vm: LectureSearchResultViewModel(model: vm.model), query: $query, size: .big)
                                .sectionStyle()
                                .padding(.bottom)
                        }
                    case .personSearch:
                        ScrollView (showsIndicators: false) {
                            PersonSearchResultScreen(vm: PersonSearchResultViewModel(model: vm.model), query: $query, size: .big)
                                .sectionStyle()
                                .padding(.bottom)
                        }
                    case .all:
                        ScrollView(showsIndicators: false) {
                            ForEach(vm.orderedTypes, id: \.rawValue) { type in
                                Group {
                                    switch type {
                                    case .Grade:
                                        if preview {
                                            GradesSearchResultScreen(vm: GradesSearchResultViewModel(model: vm.model, service: GradesService_Preview()), query: $query)
                                        } else {
                                            GradesSearchResultScreen(vm: GradesSearchResultViewModel(model: vm.model, service: GradesService()), query: $query)
                                        }
                                    case .Cafeteria:
                                        if preview {
                                            CafeteriaSearchResultScreen(vm: CafeteriaSearchResultViewModel(service: CafeteriasService_Preview()), query: $query)
                                        } else {
                                            CafeteriaSearchResultScreen(vm: CafeteriaSearchResultViewModel(service: CafeteriasService()), query: $query)
                                        }
                                        
                                    case .News:
                                        if preview {
                                            NewsSearchResultScreen(vm: NewsSearchResultViewModel(service: NewsService_Preview()), query: $query)
                                        } else {
                                            NewsSearchResultScreen(vm: NewsSearchResultViewModel(service: NewsService()), query: $query)
                                        }
                                        
                                    case .StudyRoom:
                                        if preview {
                                            StudyRoomSearchResultScreen(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService_Preview()), query: $query)
                                        } else {
                                            StudyRoomSearchResultScreen(vm: StudyRoomSearchResultViewModel(studyRoomService: StudyRoomsService()),query: $query)
                                        }
                                        
                                    case .Calendar:
                                        if preview {
                                            EventSearchResultScreen(vm: EventSearchResultViewModel(model: Model_Preview(), lecturesService: LecturesService_Preview(), calendarService: CalendarService_Preview()), query: $query)
                                        } else {
                                            EventSearchResultScreen(vm: EventSearchResultViewModel(model: self.vm.model, lecturesService: LecturesService(), calendarService: CalendarService()), query: $query)
                                        }
                                        
                                    case .Movie:
                                        if preview {
                                            MovieSearchResultScreen(vm: MovieSearchResultViewModel(service: MovieService_Preview()), query: $query, size: .big)
                                        } else {
                                            MovieSearchResultScreen(vm: MovieSearchResultViewModel(service: MovieService()), query: $query, size: .big)
                                        }
                                    }
                                }
                                .sectionStyle()
                            }
                            .padding(.bottom)
                        }
                    }
                }
            }
        }
        .searchable (text: $query, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: query) { newQuery in
            vm.search(for: newQuery)
        }
        .onAppear {
            vm.search(for: query)
        }
        .background(Color.primaryBackground)
    }
}

struct Search: ViewModifier {
    func body(content: Content) -> some View {
        content.cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 5)
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(vm: SearchResultViewModel(model: Model_Preview()))
    }
}
