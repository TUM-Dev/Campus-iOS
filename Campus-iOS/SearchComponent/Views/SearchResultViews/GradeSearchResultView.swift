//
//  GradeSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import SwiftUI

struct GradesSearchResultView: View {
    
    @StateObject var vm: GradesSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var results: [(grade: Grade, distance: Distances)] {
        switch size {
        case .small:
            return Array(vm.results.prefix(3))
        case .big:
            return Array(vm.results.prefix(10))
        }
    }
    @State var greet = "hello"
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
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
                ScrollView {
                    ForEach(self.results, id: \.grade) { result in
                        VStack {
                            GradeView(grade: result.grade).padding(.leading)
                        }
                    }
                }
            }
            
        }
        .onChange(of: query) { newQuery in
            Task {
                await vm.gradesSearch(for: newQuery)
            }
        }
        .onAppear() {
            Task {
                await vm.gradesSearch(for: query)
                self.greet = "world"
            }
        }
    }
}

struct GradesSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        GradesSearchResultView(vm: GradesSearchResultViewModel(model: Model_Preview(), service: GradeService_Preview()), query: .constant("Grundlagen"))
            .cornerRadius(25)
            .padding()
            .shadow(color: .gray.opacity(0.8), radius: 10)
    }
}

struct GradeService_Preview: GradesServiceProtocol {
    func fetch(token: String, forcedRefresh: Bool) async throws -> [Grade] {
        return Grade.previewData
    }
}
