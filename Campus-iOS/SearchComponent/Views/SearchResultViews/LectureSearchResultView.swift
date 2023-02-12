//
//  LectureSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 14.01.23.
//

import Foundation
import SwiftUI

struct LectureSearchResultView: View {
    @StateObject var vm : LectureSearchResultViewModel
    @Binding var query: String
    
    @State var size: ResultSize = .small
    
    var results: [Lecture] {
        switch size {
        case .small:
            return Array(vm.results.prefix(3))
        case .big:
            return Array(vm.results.prefix(10))
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                VStack {
                    ZStack {
                        Text("Lecture Search")
                            .fontWeight(.bold)
                            .font(.title)
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
                    ForEach(self.results, id: \.id) { result in
                        VStack(alignment: .leading) {
                            NavigationLink {
                                LectureDetailsScreen(model: self.vm.model, lecture: result)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                HStack {
                                    Text(result.title)
                                    Spacer()
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.tumBlue)
                                }
                            }.buttonStyle(.plain)
                            Divider()
                        }
                    }
                }
                if self.results.count == 0 {
                    Text("No lectures were found 😢")
                        .foregroundColor(.gray)
                }
            }.padding()
        }.onChange(of: query) { newQuery in
            Task {
                await vm.lectureSearch(for: newQuery)
            }
        }
        .onAppear() {
            Task {
                await vm.lectureSearch(for: query)
            }
        }
    }
}
