//
//  TuitionWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct TuitionWidgetView: View {
    
    @State private var size: WidgetSize
    private let initialSize: WidgetSize
    @State private var scale: CGFloat = 1
    @Binding var refresh: Bool
    
    let model: Model
    
    init(model: Model ,size: TuitionWidgetSize, refresh: Binding<Bool> = .constant(false)) {
        self.model = model
        self._size = State(initialValue: size.value)
        self.initialSize = size.value
        self._refresh = refresh
    }
    
    var body: some View {
        WidgetFrameView(size: size, content: TuitionWidgetContent(viewModel: ProfileViewModel(model: model, service: ProfileService()), size: size, refresh: $refresh))
            .expandable(size: $size, initialSize: initialSize, biggestSize: .rectangle, scale: $scale)
    }
}

struct TuitionWidgetContent: View {
    @StateObject var viewModel: ProfileViewModel
    let size: WidgetSize
    @Binding var refresh: Bool
    
    var body: some View {
        Group {
            switch viewModel.tuitionState {
            case .success(let tuition):
                if let amount = tuition.amount,
                let deadline = tuition.deadline,
                   let semester = tuition.semesterID {
                    TuitionWidgetInfoView(
                        amount: amount,
                        openAmount: tuition.isOpenAmount,
                        deadline: deadline,
                        semester: semester,
                        big: size != .square
                    )
                }
            case .loading, .na:
                    WidgetLoadingView(text: "Loading tuition fee")
            case .failed(error: let error):
                    WidgetLoadingView(text: "Error: \(error)")
            }
        }
        .onChange(of: refresh) { _ in
            Task {
                await viewModel.getTuition(forcedRefresh: true)
            }
        }
        .task {
            Task {
                await viewModel.getTuition(forcedRefresh: false)
            }
        }
    }
}

struct TuitionWidgetInfoView: View {
    
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
            .foregroundColor(.widget)
            .overlay {
                VStack(alignment: .leading) {
                    
                    Label("Tuition fees", systemImage: "eurosign.circle")
                        .font(.body.bold())
                        .lineLimit(1)
                        .padding(.bottom, 2)
                    
                    Text(self.formatter.string(from: amount) ?? "Unknown")
                        .font(.system(size: 30))
                        .foregroundColor(openAmount ? .red : .green)
                        .bold()
                    
                    HStack {
                        Text("Open Amount")
                        Text(semester)
                    }
                    .font(big ? .body : .caption)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                        
                        if (big) {
                            Text("Deadline")
                                .bold()
                        }
                        
                        Text(deadline, style: .relative)
                            .bold()
                    }
                    .font((big ? Font.body : Font.caption).bold())

                }
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
                WidgetFrameView(size: .square, content: TuitionWidgetInfoView(amount: 138.00, openAmount: true, deadline: Date(), semester: "22W", big: false))
                
                WidgetFrameView(size: .square, content: TuitionWidgetInfoView(amount: 0, openAmount: false, deadline: Date(), semester: "22S", big: false))
            }
            
            WidgetFrameView(size: .rectangle, content: TuitionWidgetInfoView(amount: 138.00, openAmount: true, deadline: Date(), semester: "22W", big: true))
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
    }
}
