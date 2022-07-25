//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetScreen: View {
    
    private let recommender: WidgetRecommender
    
    init(model: Model) {
        self.recommender = WidgetRecommender(strategy: TimeStrategy(), model: model)
    }
    
    var body: some View {
        ScrollView {
            
            // TODO: use a flexible grid.
            VStack {
                ForEach(recommender.getRecommendation(), id: \.widget) { recommendation in
                    recommender.getWidget(for: recommendation.widget, size: recommendation.size())
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}
