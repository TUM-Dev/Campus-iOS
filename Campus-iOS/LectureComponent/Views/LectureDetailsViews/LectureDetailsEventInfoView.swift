//
//  LectureDetailsEventInfoView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.02.22.
//

import SwiftUI

struct LectureDetailsEventInfoView: View {
    @StateObject var viewModel: LectureDetailsViewModel
    var event: CalendarEvent
    
    var duration: String {
        if let start = self.event.startDate, let end = self.event.endDate {
            return "\(Self.startDateFormatter.string(from: start)) - \(Self.endDateFormatter.string(from: end))"
        }
        return "n/a"
    }
    
    var location: String {
        if let location = self.event.location {
            return location
        }
        return "n/a"
    }
    
    var body: some View {
        GroupBox(
            label: GroupBoxLabelView(
                iconName: "calendar.badge.clock",
                text: "This Meeting".localized
            )
            .padding(.bottom, 10)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                LectureDetailsBasicInfoRowView(
                    iconName: "hourglass",
                    text: self.duration
                )
                Divider()
                // Open RoomfinderView
                NavigationLink(destination: RoomFinderView(model: viewModel.model, viewModel: RoomFinderViewModel(), searchText: self.location)) { // TODO: searchText should just be the room number -> filter the string
                    LectureDetailsBasicInfoRowView(
                        iconName: "rectangle.portrait.arrowtriangle.2.inward",
                        text: self.location
                    )
                }
            }
        }
        .frame(
              maxWidth: .infinity,
              alignment: .topLeading
        )
    }
    
    private static let startDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EE, dd.MM.yyyy, HH:mm"
        return formatter
    }()

    private static let endDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

struct LectureDetailsEventInfoView_Previews: PreviewProvider {
    
    static var event = CalendarEvent(id: 1, title: "Some Title", descriptionText: "Some description", startDate: Date(), endDate: Date(), location: "Some Location")
    
    static var previews: some View {
        LectureDetailsEventInfoView(viewModel: LectureDetailsViewModel(model: MockModel()), event: event)
    }
}
