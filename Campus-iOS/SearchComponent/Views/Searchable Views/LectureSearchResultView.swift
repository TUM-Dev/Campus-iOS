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
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                Text("\(vm.results.count)")
                ForEach(vm.results, id: \.id) { result in
                    HStack {
                        Text(result.title)
                        Spacer()
                        Text(result.eventType)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
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
