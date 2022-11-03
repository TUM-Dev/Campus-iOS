//
//  CalendarWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 12.07.22.
//

import SwiftUI

struct CalendarWidgetView: View {
    
    @StateObject private var viewModel: CalendarWidgetViewModel
    @State private var size: WidgetSize
    @State private var showDetails: Bool = false
    private let initialSize: WidgetSize
    @State private var scale: CGFloat = 1
    @Binding var refresh: Bool
    
    init(size: WidgetSize, refresh: Binding<Bool> = .constant(false)) {
        self._viewModel = StateObject(wrappedValue: CalendarWidgetViewModel())
        self._size = State(initialValue: size)
        self.initialSize = size
        self._refresh = refresh
    }
    
    var content: some View {
        CalendarWidgetContent(size: size, events: viewModel.upcomingEvents)
            .widgetBackground()
    }
    
    var body: some View {
        WidgetFrameView(size: size, content: content)
            .onChange(of: refresh) { _ in
                if showDetails { return }
                Task { await viewModel.fetch() }
            }
            .task {
                await viewModel.fetch()
            }
            .onTapGesture {
                showDetails.toggle()
            }
            .sheet(isPresented: $showDetails) {
                CalendarContentView(model: viewModel.getModel(), refresh: .constant(false))
            }
            .expandable(size: $size, initialSize: initialSize, scale: $scale)
    }
}

struct CalendarWidgetContent: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let size: WidgetSize
    let events: [CalendarEvent]
    
    private let displayedItems: Int
    
    init(size: WidgetSize, events: [CalendarEvent]) {
        self.size = size
        self.events = events

        
        switch size {
        case .square: displayedItems = 1
        case .rectangle: displayedItems = 1
        case .bigSquare: displayedItems = 5
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMdd")
        return formatter
    }
    
    var body: some View {
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
                    CalendarEventView(event: event, color: color())
                        .padding(.top, 8)
                }
            } else {
                Text("No events.")
                    .padding(.top, 2)
            }
            
            Spacer()
            
            let diff = events.count - displayedItems
            Group {
                if diff == 1 {
                    Text("+ 1 more event")
                } else if diff > 1 {
                    Text("+ \(diff) more events")
                }
            }
            .foregroundColor(color())
            .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    // TUM-blue has bad contrast on the dark appearance.
    private func color() -> Color {
        if colorScheme == .dark {
            return .blue
        }
        
        return .tumBlue
    }
}

struct CalendarEventView: View {
    
    let event: CalendarEvent
    let color: Color
    
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
            
            HStack(alignment: .center) {
                Capsule()
                    .frame(width: 2)
                    .foregroundColor(color)
                
                VStack(alignment: .leading) {
                    
                    let timeText = "\(timeFormatter.string(from: startDate)) - \(timeFormatter.string(from: endDate))"
                    
                    Label(timeText, systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(color)
                    
                    Text(title)
                        .font(.caption)
                        .bold()
                        .lineLimit(1)
                    
                    Label(location, systemImage: "mappin")
                        .lineLimit(1)
                        .font(.caption2)
                }
            }
            .frame(height: 40)
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
                .widgetBackground()
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
