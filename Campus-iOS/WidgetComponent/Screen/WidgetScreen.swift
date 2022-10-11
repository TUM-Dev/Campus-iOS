//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetScreen: View {
    
    @StateObject private var recommender: WidgetRecommender
    @State private var refresh = false
    
    init(model: Model) {
        self._recommender = StateObject(wrappedValue: WidgetRecommender(strategy: SpatioTemporalStrategy(), model: model))
    }
    
    var body: some View {
        
        Group {
            switch recommender.status {
            case .loading:
                ProgressView()
            case .success:
                GeometryReader { geometry in
                    ScrollView {
                        self.generateContent(in: geometry, views: recommender.recommendations.map { recommender.getWidget(for: $0.widget, size: $0.size(), refresh: $refresh) })
                            .frame(maxWidth: .infinity)
                    }
                    .refreshable {
                        try? await recommender.fetchRecommendations()
                        refresh.toggle()
                    }
                }
            }
        }
        .task {
            try? await recommender.fetchRecommendations()
        }
    }
    
    // Source: https://stackoverflow.com/a/58876712
    private func generateContent<T: View>(in g: GeometryProxy, views: [T]) -> some View {
        
        var width = CGFloat.zero
        var height = CGFloat.zero
        var previousHeight = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(0..<views.count, id: \.self) { i in
                views[i]
                    .padding([.horizontal, .vertical], WidgetSize.padding)
                    .alignmentGuide(.leading) { d in
                        
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= previousHeight
                        }
                        
                        let result = width
                        
                        if i == views.count - 1 {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        
                        previousHeight = d.height
                        
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        
                        let result = height
                        
                        if i == views.count - 1 {
                            height = 0
                        }
                        
                        return result
                    }
            }
        }
    }
}
