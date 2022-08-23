//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetScreen: View {
    
    @StateObject private var recommender: WidgetRecommender
    
    init(model: Model) {
        self._recommender = StateObject(wrappedValue: WidgetRecommender(strategy: SpatioTemporalStrategy(), model: model))
    }
    
    var body: some View {
        
        Group {
            switch recommender.status {
            case .loading:
                ProgressView()
            case .success:
                ScrollView {
                    
                    // TODO: use a flexible grid.
                    VStack {
                        ForEach(recommender.recommendations, id: \.widget) { recommendation in
                            recommender.getWidget(for: recommendation.widget, size: recommendation.size())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
        .task {
            await recommender.fetchRecommendations()
        }
    }
}
