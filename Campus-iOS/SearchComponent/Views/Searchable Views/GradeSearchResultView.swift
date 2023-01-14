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
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ForEach(vm.results, id: \.grade) { result in
                    VStack {
                        Text(result.grade.title).foregroundColor(.indigo)
                        Text(result.grade.examiner).foregroundColor(.teal)
                        Text(result.grade.grade).foregroundColor(.purple)
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
            }
        }
    }
}
