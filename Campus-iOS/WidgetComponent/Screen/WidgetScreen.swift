//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetScreen: View {
    
    @AppStorage("analyticsOptIn") private var analyticsOptIn: Bool = false
    @StateObject private var recommender: WidgetRecommender
    @State private var showOptInSheet: Bool = false
    
    init(model: Model) {
        self._recommender = StateObject(wrappedValue: WidgetRecommender(strategy: AnalyticsStrategy(), model: model))
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
                        
                        if !analyticsOptIn {
                            Button {
                                showOptInSheet.toggle()
                            } label: {
                                Text("You can help improve your widget recommendations. Click here to read more.")
                            }
                            .tint(.secondary)
                            .padding(.top, 16)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showOptInSheet) {
            AnalyticsOptInView(showMore: true)
        }
        .task {
            try? await recommender.fetchRecommendations()
        }
    }
}
