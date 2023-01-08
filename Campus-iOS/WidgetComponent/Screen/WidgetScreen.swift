//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI
import MapKit

struct WidgetScreen: View {
    
    @StateObject private var recommender: WidgetRecommender
    @StateObject var model: Model = Model()
    @State private var refresh = false
    @State private var widgetTitle = String()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    init(model: Model) {
        self._recommender = StateObject(wrappedValue: WidgetRecommender(strategy: SpatioTemporalStrategy(), model: model))
    }
    
    var body: some View {
        
        Group {
            switch recommender.status {
            case .loading:
                ProgressView()
            case .success:
                Group {
                    self.generateContent(
                        views: recommender.recommendations.map { recommender.getWidget(for: $0.widget, size: $0.size(), refresh: $refresh) }
                    )
                        .frame(maxWidth: .infinity)
                }
                .refreshable {
                    try? await recommender.fetchRecommendations()
                    refresh.toggle()
                }
            }
        }
        .task {
            try? await recommender.fetchRecommendations()
            if let firstName = model.profile.profile?.firstname { widgetTitle = "Hi, " + firstName }
            else { widgetTitle = "Welcome"}
        }
        .onReceive(timer) { _ in
            refresh.toggle()            
        }
    }
    
    // Source: https://stackoverflow.com/a/58876712
    private func generateContent<T: View>(views: [T]) -> some View {
        
        var width = CGFloat.zero
        var height = CGFloat.zero
        var previousHeight = CGFloat.zero
        let maxWidth = WidgetSize.bigSquare.dimensions.0 + 2 * WidgetSize.padding
        
        if let firstName = model.profile.profile?.firstname { widgetTitle = "Hi, " + firstName }
        else { widgetTitle = "Welcome"}
        
        return VStack(spacing: 0) {
            HStack {
                Text("study rooms, food & calendar")
                    .font(.headline.bold())
                    .textCase(.uppercase)
                    .foregroundColor(Color.highlightText)
                Spacer()
            }
            .padding(.leading, 40)
            .padding(.bottom, 5)
            ZStack(alignment: .topLeading) {
                ForEach(0..<views.count, id: \.self) { i in
                    views[i]
                        .padding([.horizontal, .vertical], WidgetSize.padding)
                        .alignmentGuide(.leading) { d in
                            
                            if (abs(width - d.width) > maxWidth) {
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
}
