//
//  GradeWidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 10.07.22.
//

import SwiftUI

@available(iOS 16.0, *)
struct GradeWidgetView: View {
    
    @StateObject var viewModel: GradesViewModel
    @State private var size: WidgetSize
    @State private var showDetails = false
    private let initialSize: WidgetSize
    @State private var scale: CGFloat = 1
    @Binding var refresh: Bool
    
    init(model: Model, size: WidgetSize, refresh: Binding<Bool> = .constant(false)) {
//        self._viewModel = StateObject(wrappedValue: GradesViewModel(model: model, service: GradesService()))
        self._viewModel = StateObject(wrappedValue: GradesViewModel(model: model, gradesService: GradesService(), averageGradesService: AverageGradesService()))
        
        self.size = size
        self.initialSize = size
        self._refresh = refresh
    }
    
    var content: some View {
        Group {
            switch viewModel.gradesState {
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
        .onChange(of: refresh) { _ in
            if showDetails { return }
            Task { await viewModel.getGrades() }
        }
        .task {
            await viewModel.getGrades()
        }
    }
    
    var body: some View {
        WidgetFrameView(size: size, content: content)
            .onTapGesture {
                showDetails.toggle()
            }
            .sheet(isPresented: $showDetails) {
                GradesView(vm: viewModel)
            }
            .expandable(size: $size, initialSize: initialSize, scale: $scale)
    }
}

struct SimpleGradeWidgetContent: View {
    
    @Environment(\.colorScheme) var colorScheme
    let grade: Grade?
    
    var gradeView: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(maxHeight: .infinity)
            .overlay {
                if let grade {
                    GeometryReader { g in
                        Text(grade.grade.isEmpty ? "tbd" : grade.grade)
                            .bold()
                            .font(.system(size: g.size.height * 0.75))
                            .foregroundColor(GradesViewModel.GradeColor.color(for: grade))
                            .if(colorScheme == .light) { view in
                                view.shadow(radius: 1.5)
                            }
                    }
                }
            }
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(.secondaryBackground)
            .overlay {
                if let grade = grade {
                    VStack(alignment: .leading) {
                        
                        gradeView
                        
                        Spacer()
                        
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
            .foregroundColor(.secondaryBackground)
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
                Text(grade.grade.isEmpty ? "tbd" : grade.grade)
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
