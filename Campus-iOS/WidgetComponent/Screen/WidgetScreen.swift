//
//  WidgetScreen.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI
import MapKit
import NaturalLanguage
import CoreML

struct WidgetScreen: View {
    
    @Environment(\.isSearching) var isSearching
    
    @StateObject private var recommender: WidgetRecommender
    @StateObject var model: Model = Model()
    @State private var refresh = false
    @State private var widgetTitle = String()
    @State private var searchString = ""
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
                SearchView(query: $searchString) {
                    ScrollView {
                        self.generateContent(
                            views: recommender.recommendations.map { recommender.getWidget(for: $0.widget, size: $0.size(), refresh: $refresh) }
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                .searchable(text: $searchString)
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
        
        return ZStack(alignment: .topLeading) {
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
        .navigationTitle(widgetTitle)
    }
}

struct SearchView<Content: View> : View {
    
    @Binding var query: String
    @Environment(\.isSearching) var isSearching
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        if isSearching {
            SearchResultView(query: $query)
        } else {
            content()
        }
        
    }
}

struct SearchResultView: View {
    @StateObject var vm = SearchResultViewModel()
    @Binding var query: String
    
    var body: some View {
        VStack {
            Text("Your results for: \(query)")
            Spacer()
            ForEach(Array(vm.searchDataTypeResult.keys)) { key in
                if let accuracy = vm.searchDataTypeResult[key] {
                    Text("\(key) with accuracy of \(Int(accuracy*100)) %.")
                }
            }
            generateResultViews(for: vm.searchResults)
            Spacer()
        }.onChange(of: query) { newQuery in
            vm.search(for: newQuery)
        }
    }
    
    @ViewBuilder
    func generateResultViews(for results: [SearchResult]) -> some View {
        ForEach(0..<results.count, id: \.self) { id in
            getResultView(for: results[id])
        }
    }
    
    @ViewBuilder
    func getResultView(for result: SearchResult) -> some View {
        switch result.type {
        case .Grade:
            VStack{
                Text("Grade")
                if let grades = result.values as? [Grade] {
                    ForEach(0..<grades.count, id: \.self) { id in
                        VStack {
                            Text(grades[id].title)
                            Text(grades[id].grade)
                        }
                    }
                }
            }
        case .Lecture:
            VStack{
                Text("Lecture")
                if let lectures = result.values as? [Lecture] {
                    ForEach(0..<lectures.count, id: \.self) { id in
                        VStack {
                            Text(lectures[id].title)
                            Text(lectures[id].semester)
                        }
                    }
                }
            }
            
        case .Cafeteria:
            VStack{
                Text("Cafeteria")
                if let cafeterias = result.values as? [Cafeteria] {
                    ForEach(0..<cafeterias.count, id: \.self) { id in
                        VStack {
                            Text(cafeterias[id].name)
                            Text(cafeterias[id].queueStatusApi ?? "n.a.")
                        }
                    }
                }
            }
        case .News:
            Text("News")
        case .StudyRoom:
            Text("StudyRoom")
        }
    }
}

class SearchResultViewModel: ObservableObject {
    @Published var searchResults = [SearchResult]()
    @Published var searchDataTypeResult = [String:Double]()
    
    private lazy var dataTypeClassifier: NLModel? = {
        let model = try? NLModel(mlModel: DataTypeClassifierV2(configuration: MLModelConfiguration()).model)
            return model
        }()
    
    func search(for query: String) {
        
        guard let modelOutput = dataTypeClassifier?.predictedLabelHypotheses(for: query, maximumCount: 5) else {
            return
        }
        for (label, accuracy) in modelOutput {
            print("\(label) was at \(accuracy)")
        }
        searchDataTypeResult = modelOutput
        
        if query.contains("Grade") {
            searchResults.append(SearchResult(type: .Grade, values: Grade.dummyData))
            searchResults.append(SearchResult(type: .Lecture, values: Lecture.dummyData))
        }
    }
    
    
}

struct SearchResult {
    let type: SearchResultType
    var values: [Decodable]
}

enum SearchResultType: String {
    case Grade
    case Lecture
    case News
    case Cafeteria
    case StudyRoom
}

struct WidgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        WidgetScreen(model: Model())
    }
}
