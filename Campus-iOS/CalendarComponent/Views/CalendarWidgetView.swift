//
//  CalendarWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 12.07.22.
//

import SwiftUI

struct CalendarWidgetView: View {
    
    @StateObject var viewModel: CalendarViewModel
    let size: WidgetSize
    
    init(model: Model, size: WidgetSize) {
        self.size = size
        self._viewModel = StateObject(wrappedValue: CalendarViewModel(model: model))  // Fetches in init.
    }
    
    var body: some View {
        
        // Show the events on the earliest date which is not in the past.
        let events = viewModel.eventsByDate
            .filter { Date() <= $0.key ?? Date() }
            .min { $0.key ?? Date() < $1.key ?? Date() }?.value ?? []
        
        WidgetFrameView(
            size: size,
            content: CalendarWidgetContent(size: size, events: events)
        )
    }
}

struct CalendarWidgetContent: View {
    
    let size: WidgetSize
    let events: [CalendarEvent]
    
    private let displayedItems: Int
    
    init(size: WidgetSize, events: [CalendarEvent]) {
        self.size = size
        self.events = events

        
        switch size {
        case .square: displayedItems = 1
        case .rectangle: displayedItems = 2
        case .bigSquare: displayedItems = 5
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMdd")
        return formatter
    }
    
    var content: some View {
        
        VStack(alignment: .leading) {
            
            // Title
            HStack {
                Image(systemName: "calendar")
                
                if let firstDate = events.first?.startDate {
                    if firstDate.isToday {
                        Text("Today")
                    } else if firstDate.isTomorrow {
                        Text("Tomorrow")
                    } else {
                        Text(dateFormatter.string(from: firstDate))
                    }
                } else if let _ = events.first {
                    Text("Unknown Date")
                } else {
                    Text("Today") // Today no events.
                }
            }
            .font(.body.bold())
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)

            if !events.isEmpty {
                ForEach(events.prefix(displayedItems), id: \.id) { event in
                    // Allow multiline if the content will likely not fit inside one line.
                    CalendarEventView(event: event, allowMultiline: size == .square)
                }
            } else {
                Text("No events.")
                    .padding(.top, 2)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(.widget)
            .overlay {
                content
            }
    }
}

struct CalendarEventView: View {
    
    let event: CalendarEvent
    let allowMultiline: Bool
    
    @State private var height: CGFloat = 0
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var body: some View {
        if let startDate = event.startDate,
           let endDate = event.endDate,
           let title = event.title,
           let location = event.location {
            HStack(alignment: .top) {
                Capsule()
                    .frame(width: 2, height: height)
                    .foregroundColor(.tumBlue)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.caption)
                        .bold()
                        .lineLimit(allowMultiline ? 2 : 1)
                    
                    Group {
                        let timeText = timeFormatter.string(from: startDate) +
                            " - " + timeFormatter.string(from: endDate)
                        
                        Label(timeText, systemImage: "clock")
                            .lineLimit(1)
                        
                        Label(location, systemImage: "mappin")
                            .lineLimit(allowMultiline ? 3 : 1)
                    }
                    .font(.caption2)
                }
                
                // Via https://stackoverflow.com/a/60346544
                .alignmentGuide(.top, computeValue: { d in
                    DispatchQueue.main.async {
                        self.height = max(d.height, self.height)
                    }
                    return d[.top]
                })
            }
        } else {
            Text("Error")
        }
    }
}

struct CalendarWidgetView_Previews: PreviewProvider {
    
    
    static let events = [CalendarEvent](repeating: CalendarEvent.mockEvent, count: 7)
    
    struct Widget: View {
        
        let size: WidgetSize
        let events: [CalendarEvent]
        
        var body: some View {
            WidgetFrameView(
                size: size,
                content: CalendarWidgetContent(
                    size: size,
                    events: events
                )
            )
        }
    }
    
    static var content: some View {
        VStack {
            HStack {
                Widget(size: .square, events: events)
                Widget(size: .square, events: [])
            }
            
            Widget(size: .rectangle, events: events)
            Widget(size: .bigSquare, events: events)
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
    }
}
