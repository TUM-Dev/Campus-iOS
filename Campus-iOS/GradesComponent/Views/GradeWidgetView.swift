//
//  GradeWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 10.07.22.
//

import SwiftUI

struct GradeWidgetView: View {
    
    @StateObject var viewModel: GradesViewModel
    var size: WidgetSize
    
    init(model: Model, size: WidgetSize) {
        self._viewModel = StateObject(wrappedValue: GradesViewModel(model: model, service: GradesService()))
        self.size = size
    }
    
    var content: some View {
        Group {
            switch viewModel.state {
            case .success:
                switch size {
                case .square:
                    SimpleGradeWidgetContent(grade: viewModel.grades.first)
                case .rectangle, .bigSquare:
                    DetailedGradeWidgetContent(grades: viewModel.grades, size: size)
                }
            case .loading, .na:
                WidgetLoadingView(text: "Fetching Grades")
            case .failed:
                TextWidgetView(text: "There was an error fetching the grades.")
            }
        }
        .task {
            await viewModel.getGrades()
        }
    }
    
    var body: some View {
        WidgetFrameView(size: size, content: content)
    }
}

struct SimpleGradeWidgetContent: View {
    
    @Environment(\.colorScheme) var colorScheme
    let grade: Grade?
    
    var body: some View {
        Rectangle()
            .foregroundColor(.widget)
            .overlay {
                if let grade = grade {
                    VStack(alignment: .leading) {
                        Text(grade.grade)
                            .bold()
                            .font(.system(size: 45))
                            .foregroundColor(GradesViewModel.GradeColor.color(for: grade))
                            .if(colorScheme == .light) { view in
                                view.shadow(radius: 1.5)
                            }
                            .padding(.bottom, 4)
                        
                        HStack {
                            Image(systemName: "pencil")
                            Text(grade.title)
                                .lineLimit(2)
                        }
                        .font(.caption.bold())
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 2)
                        
                        Label(grade.examiner, systemImage: "person")
                            .font(.caption)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                } else {
                    Text("No grades")
                }
            }
    }
}

struct DetailedGradeWidgetContent: View {
    
    let grades: [Grade]
    let size: WidgetSize
    
    private let displayedItems: Int
    
    init(grades: [Grade], size: WidgetSize) {
        self.grades = grades
        self.size = size
        
        switch size {
        case .bigSquare:
            self.displayedItems = 5
        case .rectangle:
            self.displayedItems = 2
        default:
            self.displayedItems = 1
        }
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(.widget)
            .overlay {
                VStack(alignment: .leading) {
                    
                    Label("My Grades", systemImage: "checkmark.shield")
                        .font(.body.bold())
                        .padding(.bottom, 2)
                    
                    Spacer()
                    
                    if (grades.isEmpty) {
                        Text("No grades.")
                    } else {
                        ForEach(grades.prefix(displayedItems), id: \.id) { grade in
                            HStack {

                                GradeSquareView(grade: grade)
                                
                                VStack(alignment: .leading) {
                                    Text(grade.title)
                                        .font(.caption)
                                        .bold()
                                        .lineLimit(1)

                                    Label(grade.examiner, systemImage: "person")
                                        .font(.caption)
                                    
                                    HStack {
                                        Label(grade.modusShort, systemImage: "pencil")
                                        Label(grade.lvNumber, systemImage: "number")
                                    }
                                    .font(.caption2)
                                }
                            }
                        }
                    }
                     
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
    }
}

struct GradeSquareView: View {
    
    let grade: Grade
    
    var body: some View {
        Rectangle()
            .foregroundColor(GradesViewModel.GradeColor.color(for: grade))
            .frame(width: 40, height: 40)
            .cornerRadius(4)
            .overlay {
                Text(grade.grade)
                    .bold()
                    .foregroundColor(.white)
                    .glowBorder(color: .gray, lineWidth: 1)
            }
    }
}

struct GradeWidgetView_Previews: PreviewProvider {
    
    static var content: some View {
        ScrollView {
            VStack {
                HStack {
                    WidgetFrameView(size: .square, content: SimpleGradeWidgetContent(grade: Grade.dummyDataAll.first))
                    WidgetFrameView(size: .square, content: SimpleGradeWidgetContent(grade: nil))
                }
                WidgetFrameView(size: .rectangle, content: DetailedGradeWidgetContent(grades: Grade.dummyDataAll, size: .rectangle))
                WidgetFrameView(size: .bigSquare, content: DetailedGradeWidgetContent(grades: Grade.dummyDataAll, size: .bigSquare))
                WidgetFrameView(size: .rectangle, content: DetailedGradeWidgetContent(grades: [], size: .rectangle))
            }
            .padding()
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
    }
}
