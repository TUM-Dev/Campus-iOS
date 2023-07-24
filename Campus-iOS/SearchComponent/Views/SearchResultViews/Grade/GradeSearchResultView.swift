//
//  GradeSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct GradesSearchResultView: View {
    
    let allResults: [(grade: Grade, distance: Distances)]
    @State var size: ResultSize = .small
    
    var results: [(grade: Grade, distance: Distances)] {
        switch size {
        case .small:
            return Array(allResults.prefix(3))
        case .big:
            return Array(allResults.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.shield")
                            .fontWeight(.semibold)
                            .font(.title2)
                            .foregroundColor(Color.highlightText)
                        Text("Grades")
                            .fontWeight(.semibold)
                            .font(.title2)
                            .foregroundColor(Color.highlightText)
                        Spacer()
                        ExpandIcon(size: $size)
                    }
                    Divider()
                }
                ScrollView {
                    ForEach(self.results, id: \.grade) { result in
                        VStack {
                            GradeView(grade: result.grade)
                        }
                    }
                }
            }
        }
    }
}

struct GradesSearchResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        GradesSearchResultScreen(vm: GradesSearchResultViewModel(model: Model_Preview(), service: GradesService_Preview()), query: .constant("Grundlagen"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct GradesService_Preview: GradesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [Grade] {
        return Grade.previewData
    }
    
    func fetchGrades(token: String, forcedRefresh: Bool) async throws -> [Grade] {
        return Grade.previewData
    }
    
    func fetchGradesSemesterDegrees(token: String, forcedRefresh: Bool) async throws -> GradesSemesterDegrees {
        return []
    }
}
