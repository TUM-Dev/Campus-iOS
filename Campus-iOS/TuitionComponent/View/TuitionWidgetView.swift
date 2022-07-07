//
//  TuitionWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct TuitionWidgetView: View {
    
    let size: TuitionWidgetSize
    
    var body: some View {
        WidgetFrameView(size: size.value, content: TuitionWidgetContent(size: size))
    }
}

struct TuitionWidgetContent: View {
    @StateObject var viewModel = ProfileViewModel()
    let size: TuitionWidgetSize
    
    var body: some View {
        Group {
            if let tuition = self.viewModel.tuition,
               let amount = tuition.amount,
               let deadline = tuition.deadline,
               let semester = tuition.semesterID {
                TuitionWidgetSquareContent(
                    amount: amount,
                    openAmount: tuition.isOpenAmount,
                    deadline: deadline,
                    semester: semester,
                    big: size != .square
                )
            } else {
                WidgetLoadingView(text: "Loading tuition fee")
            }
        }
        .task {
            viewModel.fetch()
        }
    }
}

struct TuitionWidgetSquareContent: View {
    
    let amount: NSDecimalNumber
    let openAmount: Bool
    let deadline: Date
    let semester: String
    let big: Bool
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = "€ "
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        
        Rectangle()
            .foregroundColor(openAmount ? .red : .green)
            .overlay {
                VStack(alignment: .leading) {
                    
                    Text("Tuition fees")
                        .font(.caption)
                    
                    Text(self.formatter.string(from: amount) ?? "Unknown")
                        .font(.system(size: big ? 45 : 30))
                        .bold()
                    
                    HStack {
                        Text("Open Amount")
                            .font(.caption)
                        
                        Text(semester)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.caption.weight(.bold))
                        
                        if (big) {
                            Text("Deadline")
                                .font(.caption)
                                .bold()
                        }
                        
                        Text(deadline, style: .relative)
                            .font(.caption)
                            .bold()
                    }
                    
                    
                }
                .foregroundColor(.white) // White font.
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
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
}

struct TuitionWidgetView_Previews: PreviewProvider {
    
    static var content: some View {
        VStack {
            HStack{
                WidgetFrameView(size: .square, content: TuitionWidgetSquareContent(amount: 138.00, openAmount: true, deadline: Date(), semester: "22W", big: false))
                
                WidgetFrameView(size: .square, content: TuitionWidgetSquareContent(amount: 0, openAmount: false, deadline: Date(), semester: "22S", big: false))
            }
            
            WidgetFrameView(size: .rectangle, content: TuitionWidgetSquareContent(amount: 138.00, openAmount: true, deadline: Date(), semester: "22W", big: true))
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
    }
}
