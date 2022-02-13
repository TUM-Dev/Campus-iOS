//
//  CalendarSingleEventView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct CalendarSingleEventView: View {
    
    @EnvironmentObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var viewModel: LectureDetailsViewModel = LectureDetailsViewModel(
        serivce: LectureDetailsService()
    )
    @State var event: CalendarEvent?
    
    private var token: String? {
        switch self.model.loginController.credentials {
        case .none, .noTumID:
            return nil
        case .tumID(_, let token):
            return token
        case .tumIDAndKey(_, let token, _):
            return token
        }
    }
    
    var lvNr: String? {
        if let url = self.event?.url?.description, let range = url.range(of: "LvNr=") {
            return String(url[range.upperBound...])
        }
        return nil
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
                            FailedView(errorDescription: error.localizedDescription)
                        }
                    }
                    .task {
                        guard let token = self.token, let lvNr = Double(self.lvNr ?? "") else {
                            return
                        }
                        
                        await viewModel.getLectureDetails(
                            token: token,
                            lvNr: UInt64(lvNr)
                        )
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
        CalendarSingleEventView(event: event)
    }
}
