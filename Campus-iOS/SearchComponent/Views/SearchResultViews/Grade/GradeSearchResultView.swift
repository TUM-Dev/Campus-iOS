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
                    ZStack {
                        Text("Grades")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                        HStack {
                            Spacer()
                            Button {
                                switch size {
                                case .big:
                                    withAnimation {
                                        self.size = .small
                                    }
                                case .small:
                                    withAnimation {
                                        self.size = .big
                                    }
                                }
                            } label: {
                                if self.size == .small {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .padding()
                                } else {
                                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                                        .padding()
                                }
                            }
                        }
                    }
                }
                ScrollView {
                    ForEach(self.results, id: \.grade) { result in
                        VStack {
                            GradeView(grade: result.grade).padding(.leading)
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
