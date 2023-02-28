//
//  DeparturesDetailsRowView.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import SwiftUI

struct DeparturesDetailsRowView: View {
    
    @StateObject var departuresViewModel: DepaturesWidgetViewModel
    
    @State var showWarningURL = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var departure: Departure
    
    var body: some View {
        VStack {
            HStack {
                lineNumberRectangle
                Text(departure.servingLine.direction)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
                delayText()
                timeText()
                    .frame(width: 50)
                    .font(.system(.callout, weight: .medium))
                    .multilineTextAlignment(.center)
                
            }
        }
        .fullScreenCover(isPresented: $showWarningURL) {
            if let url = URL(string: departure.lineInfos?.lineInfo.additionalLinks?[0].linkURL ?? "") {
                SFSafariViewWrapper(url: url)
                    .edgesIgnoringSafeArea(.vertical)
            }
        }
    }
    
    var lineNumberRectangle: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: 50, height: 30)
            .foregroundColor(departure.servingLine.mapColor())
            .overlay {
                Text(departure.servingLine.number)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .overlay {
                warningOverlay()
            }
            .padding(.trailing)
    }
    
    @ViewBuilder
    func warningOverlay() -> some View {
        if departure.lineInfos != nil {
            Button {
                showWarningURL = true
            } label: {
                GeometryReader { geo in
                    Image(systemName: "exclamationmark.triangle.fill")
                        .renderingMode(.original)
                        .position(
                            x: geo.size.width,
                            y: geo.size.height * 0.1
                        )
                }
            }
        }
    }
    
    @ViewBuilder
    func timeText() -> some View {
        if let realDateTime = departure.realDateTime {
            if departure.servingLine.delay ?? 0 > 0 {
                timeBuilder(realDateTime)
                    .foregroundColor(.red)
            } else {
                timeBuilder(realDateTime)
                    .foregroundColor(.green)
            }
        } else {
            timeBuilder(departure.dateTime)
        }
    }
    
    @ViewBuilder
    func timeBuilder(_ dateTime: DepartureDateTime) -> some View {
        if departure.countdown < 1 {
            Text("Now")
        } else {
            let hour = String(format: "%02d", dateTime.hour)
            let minute = String(format: "%02d", dateTime.minute)
            Text("\(hour):\(minute)")
        }
    }
    
    @ViewBuilder
    func delayText() -> some View {
        if let delay = departure.servingLine.delay {
            if delay > 0 {
                Text("+\(String(format: "%02d", delay))")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
    }
}

struct DeparturesDetailsRowView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesDetailsRowView(
            departuresViewModel: DepaturesWidgetViewModel(),
            departure: Departure(
                stopID: 0,
                countdown: 0,
                dateTime: DepartureDateTime(
                    year: 2023,
                    month: 02,
                    day: 27,
                    weekday: 2,
                    hour: 10,
                    minute: 23
                ),
                realDateTime: DepartureDateTime(
                    year: 2023,
                    month: 02,
                    day: 27,
                    weekday: 2,
                    hour: 10,
                    minute: 25
                ),
                servingLine: ServingLine(
                    key: 0,
                    code: 1,
                    number: "U6",
                    symbol: "U6",
                    delay: 2,
                    direction: "Klinikum Großhadern",
                    name: ""
                ),
                lineInfos: nil
            )
        )
    }
}
