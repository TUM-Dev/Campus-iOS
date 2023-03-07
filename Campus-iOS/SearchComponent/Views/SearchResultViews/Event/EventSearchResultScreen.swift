//
//  EventSearchResultScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct EventSearchResultScreen: View {
    @StateObject var vm: EventSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                EventSearchResultView(allResults: data, model: vm.model, size: self.size)
            case .loading, .na:
                SearchResultLoadingView(title: "Lectures")
            case .failed(let error):
                SearchResultErrorView(title: "Lectures", error: error.localizedDescription)
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.eventsSearch(for: query)
            }
        }.task {
            await vm.eventsSearch(for: query)
        }
    }
}

struct EventSearchResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        EventSearchResultScreen(vm: EventSearchResultViewModel(model: Model_Preview(), lecturesService: LecturesService_Preview(), calendarService: CalendarService_Preview()), query: .constant("Analysis"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct LecturesService_Preview: LecturesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool = false) async throws -> [Lecture] {
        return Lecture.dummyData
    }
}

struct CalendarService_Preview: CalendarServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [CalendarEvent] {
        return CalendarEvent.previewData
    }
}
