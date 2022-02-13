//
//  CalendarSingleEventView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct CalendarSingleEventView: View {
    
    @Environment(\.presentationMode) private var presentationMode

    @State var event: CalendarEvent?
    
    var body: some View {
        NavigationView {
            VStack {
                if let chosenEvent = event {
                    Text(chosenEvent.title ?? "No title")
                } else {
                    Text("No such event!")
                }
            }
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
