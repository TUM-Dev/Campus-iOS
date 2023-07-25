//
//  LectureSearchResultView.swift
//  Campus-iOS
//
//  Created by David Lin on 14.01.23.
//

import Foundation
import SwiftUI

struct LectureSearchResultView: View {
    
    let allResults: [Lecture]
    let model: Model
    @State var size: ResultSize = .small
    
    var results: [Lecture] {
        switch size {
        case .small:
            return Array(allResults.prefix(3))
        case .big:
            return Array(allResults.prefix(10))
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "studentdesk")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Text("Lectures")
                        .lineLimit(1)
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(Color.highlightText)
                    Spacer()
                    ExpandIcon(size: $size)
                }
                Divider()
            }
            ScrollView {
                ForEach(self.results, id: \.id) { result in
                    VStack(alignment: .leading) {
                        NavigationLink {
                            LectureDetailsScreen(model: self.model, lecture: result)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            HStack {
                                Text(result.title)
                                Spacer()
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color.highlightText)
                            }
                        }.buttonStyle(.plain)
                        if results.last != nil {
                            if result != results.last! {
                                Divider()
                            }
                        }
                    }
                }
            }
            if self.results.count == 0 {
                Text("No lectures were found 😢")
                    .foregroundColor(.gray)
            }
        }
    }
}
