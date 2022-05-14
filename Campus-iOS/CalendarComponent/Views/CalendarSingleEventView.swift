//
//  CalendarSingleEventView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI
import KVKCalendar

struct CalendarSingleEventView: View {
    
    @EnvironmentObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var viewModel: LectureDetailsViewModel
    @State var event: CalendarEvent?
    
    init(model: Model, event: CalendarEvent?) {
        var lvNr: String? {
            if let url = event?.url?.description, let range = url.range(of: "LvNr=") {
                return String(url[range.upperBound...])
            }
            
            return nil
        }
        
        self._viewModel = StateObject(wrappedValue:
            LectureDetailsViewModel(
                model: model,
                serivce: LectureDetailsService(),
                // Yes, it is a really hacky solution...
                lecture: Lecture(id: UInt64(lvNr ?? "") ?? 0, lvNumber: UInt64(lvNr ?? "") ?? 0, title: "", duration: "", stp_sp_sst: "", eventTypeDefault: "", eventTypeTag: "", semesterYear: "", semesterType: "", semester: "", semesterID: "", organisationNumber: 0, organisation: "", organisationTag: "", speaker: "")
            )
        )
        self.event = event
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let chosenEvent = event {
                    Group {
                        switch viewModel.state {
                        case .success(let data):
                            LecturesDetailView(lectureDetails: data, calendarEvent: chosenEvent)
                        case .loading, .na:
                            LoadingView(text: "Fetching details of event")
                        case .failed(let error):
                            FailedView(
                                errorDescription: error.localizedDescription,
                                retryClosure: viewModel.getLectureDetails
                            )
                        }
                    }
                    .task {
                        await viewModel.getLectureDetails()
                    }
                } else {
                    Text("No such event!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.gray)
                        .opacity(0.75)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                    Text("Cancel").bold()
                }
            }
        }
    }
}

struct CalendarSingleEventView_Previews: PreviewProvider {
    
    static var event = CalendarEvent(id: 0, title: "Test Event")
    
    static var previews: some View {
        CalendarSingleEventView(model: MockModel(), event: event)
    }
}
