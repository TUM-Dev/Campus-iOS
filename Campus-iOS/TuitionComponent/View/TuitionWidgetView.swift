//
//  TuitionWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct TuitionWidgetView: View {
    
    @StateObject var viewModel = TuitionWidgetViewModel()
    @State private var size: WidgetSize
    private let initialSize: WidgetSize
    @State private var scale: CGFloat = 1
    @Binding var refresh: Bool
    
    init(size: TuitionWidgetSize, refresh: Binding<Bool> = .constant(false)) {
        self._size = State(initialValue: size.value)
        self.initialSize = size.value
        self._refresh = refresh
    }
    
    var content: some View {
        Group {
            if let tuition = self.viewModel.tuition,
               let amount = tuition.amount,
               let deadline = tuition.deadline,
               let semester = tuition.semesterID {
                TuitionWidgetContent(
                    size: size,
                    amount: amount,
                    deadline: deadline,
                    semesterID: semester
                )
                .widgetBackground()
            } else {
                WidgetLoadingView(text: "Loading tuition fee")
            }
        }
    }
    
    var body: some View {
        WidgetFrameView(size: size, content: content)
            .expandable(size: $size, initialSize: initialSize, biggestSize: .rectangle, scale: $scale)
            .onChange(of: refresh) { _ in
                Task { await viewModel.fetch() }
            }
            .task {
                await viewModel.fetch()
            }
    }
}

struct TuitionWidgetContent: View {
    
    let size: WidgetSize
    let amount: NSDecimalNumber
    let deadline: Date
    let semesterID: String
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = "€ "
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Label("Tuition fees", systemImage: "eurosign.circle")
                .font(.body.bold())
                .lineLimit(1)
                .padding(.bottom, 2)
            
            Text(self.formatter.string(from: amount) ?? "Unknown")
                .font(.system(size: 30))
                .foregroundColor(amount.floatValue > 0 ? .red : .green)
                .bold()
            
            HStack {
                Text("Open Amount")
                Text(semesterID)
            }
            .font(size == .square ? .caption : .body)
            
            Spacer()
            
            HStack {
                Image(systemName: "calendar.badge.exclamationmark")
                
                if (size != .square) {
                    Text("Deadline")
                        .bold()
                }
                
                Text(deadline, style: .relative)
                    .bold()
            }
            .font((size == .square ? Font.caption : Font.body).bold())

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

enum TuitionWidgetSize {
    
    case square, rectangle
    
    var value: WidgetSize {
        switch self {
        case .square: return WidgetSize.square
        case .rectangle: return WidgetSize.rectangle
        }
    }
    
    static func from(widgetSize: WidgetSize) -> TuitionWidgetSize {
        switch widgetSize {
        case .square:
            return TuitionWidgetSize.square
        case .rectangle, .bigSquare:
            return TuitionWidgetSize.rectangle
        }
    }
}

struct TuitionWidgetView_Previews: PreviewProvider {
    
    static var content: some View {
        VStack {
            HStack{
                WidgetFrameView(size: .square, content: TuitionWidgetContent(size: .square, amount: 138.00, deadline: Date(), semesterID: "22W").widgetBackground())
                
                WidgetFrameView(size: .square, content: TuitionWidgetContent(size: .square, amount: 0, deadline: Date(), semesterID: "22S").widgetBackground())
            }
            
            WidgetFrameView(size: .rectangle, content: TuitionWidgetContent(size: .rectangle, amount: 138.00, deadline: Date(), semesterID: "22W").widgetBackground())
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
    }
}
