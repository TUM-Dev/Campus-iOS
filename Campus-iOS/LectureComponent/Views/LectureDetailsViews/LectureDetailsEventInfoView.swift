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
                VStack (alignment: .leading) {
                    LectureDetailsBasicInfoRowView(
                        iconName: "rectangle.portrait.arrowtriangle.2.inward",
                        text: self.location
                    )
                    HStack {
                        Spacer()
                        NavigationLink(destination: RoomFinderView(model: viewModel.model, viewModel: RoomFinderViewModel(), searchText: extract(room: self.location))) {
                            HStack {
                                Text("Open in RoomFinder")
                                Image(systemName: "arrow.right.circle")
                            }.foregroundColor(Color(UIColor.tumBlue))
                                .font(.footnote)
                        }
                    }
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
    
    func extract(room: String) -> String {
        var roomNumber = room

        if let openBraceRange = roomNumber.range(of: "(") {
            roomNumber.removeSubrange(roomNumber.startIndex..<openBraceRange.upperBound)
        }
        
        if let closeBraceRange = roomNumber.range(of: ")") {
            roomNumber.removeSubrange(closeBraceRange.lowerBound..<roomNumber.endIndex)
        }
        
        return roomNumber
    }
}

struct LectureDetailsEventInfoView_Previews: PreviewProvider {
    
    static var event = CalendarEvent(id: 1, title: "Some Title", descriptionText: "Some description", startDate: Date(), endDate: Date(), location: "Some long long long long long location (1234.01.001)")
    
    static var previews: some View {
        LectureDetailsEventInfoView(viewModel: LectureDetailsViewModel(model: MockModel()), event: event)
    }
}
