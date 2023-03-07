//
//  GradeSearchResultScreen.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct GradesSearchResultScreen: View {
    @StateObject var vm: GradesSearchResultViewModel
    @Binding var query: String
    @State var size: ResultSize = .small
    
    var body: some View {
        Group {
            switch vm.state {
            case .success(let data):
                GradesSearchResultView(allResults: data, size: self.size)
            case .loading, .na:
                ZStack {
                    Color.white
                    VStack {
                        Text("Grades")
                            .fontWeight(.bold)
                            .font(.title)
                        LoadingView(text: "Searching in grades...")
                    }.padding()
                }
            case .failed(let error):
                ZStack {
                    Color.white
                    VStack {
                        Text("Grades")
                            .fontWeight(.bold)
                            .font(.title)
                        Text("Error searching in grades: \(error.localizedDescription)")
                    }.padding()
                }
            }
        }.onChange(of: query) { newQuery in
            Task {
                await vm.gradesSearch(for: newQuery)
            }
        }
        .task {
            await vm.gradesSearch(for: query)
        }
    }
}
