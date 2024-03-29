//
//  DeparturesDetailsRowView.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import SwiftUI

struct DeparturesDetailsRowView: View {
    
    @StateObject var departuresViewModel: DeparturesWidgetViewModel
    
    @State var showWarningURL = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var departure: Departure
    
    var body: some View {
        VStack {
            HStack {
                lineNumberRectangle
                Text(departure.servingLine.direction)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
                delayText()
                timeText()
                    .frame(width: 50)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                
            }
        }
        .fullScreenCover(isPresented: $showWarningURL) {
            if let lineInfos = departure.lineInfos {
                cover(lineInfos: lineInfos)
            }
        }
    }
    
    @ViewBuilder
    func cover(lineInfos: LineInfosType) -> some View {
        switch lineInfos {
        case .element(let lineInfo):
            if let url = URL(string: lineInfo.lineInfo.additionalLinks?[0].linkURL ?? "") {
                SFSafariViewWrapper(url: url)
                    .edgesIgnoringSafeArea(.vertical)
            }
        case .array(let lineInfos):
            if let url = URL(string: lineInfos[0].additionalLinks?[0].linkURL ?? "") {
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
            .buttonStyle(PlainButtonStyle())
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
        if departure.countdown + (departuresViewModel.walkingDistance ?? 0) < 1 {
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
            departuresViewModel: DeparturesWidgetViewModel(),
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
