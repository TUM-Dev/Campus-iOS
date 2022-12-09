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
                SearchView(model: self.model, query: $searchString) {
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
    
    @ObservedObject var model: Model
    @Binding var query: String
    @Environment(\.isSearching) var isSearching
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        if isSearching {
            SearchResultView(vm: SearchResultViewModel(model: self.model), query: $query)
        } else {
            content()
        }
        
    }
}

struct SearchResultView: View {
    @StateObject var vm: SearchResultViewModel
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
            GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model), query: $query)
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
    @ObservedObject var model: Model
    
    init(model: Model) {
        self.model = model
    }
    
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
//        searchResults = modelOutput.map {
//            return SearchResult(type: <#T##SearchResultType#>, values: <#T##[Decodable]#>)
//        }
        
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

struct GradesSearchResultView: View {
    
    @StateObject var vm: GradesSearchResultViewModel
    @Binding var query: String
    
    var body: some View {
        ScrollView {
            ForEach(vm.results, id: \.0) { result in
                //            Text("Grade ID: \(result.0)")
                VStack {
                    Text(vm.vm.grades.first { $0.id == result.0 }?.title ?? "no title").foregroundColor(.blue)
                    Text(vm.vm.grades.first { $0.id == result.0 }?.examiner ?? "no examiner").foregroundColor(.indigo)
                    Text(vm.vm.grades.first { $0.id == result.0 }?.grade ?? "no grade").foregroundColor(.red)
                }
            }
        }
        .onChange(of: query) { newQuery in
            print(query)
            Task {
                await vm.gradesSearch(for: newQuery)
            }
        }
        .task {
            await vm.fetch()
        }
    }
}

class GradesSearchResultViewModel: ObservableObject {
    @ObservedObject var vm: GradesViewModel
    @Published var results = [(String, Int)]()
    
    init(model: Model) {
        self.vm = GradesViewModel(model: model, service: GradesService())
    }
    
    func gradesSearch(for query: String) async {
        await fetch()
        let tokens = tokenize(query)
        
        let grades = vm.grades
        
//        var tokenWithResults = [String: [String: Int]]()
        var levenstheinValues = [String: Int]()
        for token in tokens {
            
            
            for grade in grades {
                print(grade.title)
                let gradeTokens = tokenize(grade.title) + tokenize(grade.examiner) + [grade.grade] + tokenize(grade.lvNumber)
                print(gradeTokens)
                guard let value = bestLevensthein(for: token, comparisonTokens: gradeTokens) else {
                    return
                }
                print(value)
                
                if let currentValue = levenstheinValues[grade.id], currentValue > value {
                    levenstheinValues[grade.id] = value
                } else if levenstheinValues[grade.id] == nil {
                    levenstheinValues[grade.id] = value
                }
                
            }
            
//            tokenWithResults[token] = levenstheinValues
        }
        
        results = levenstheinValues.sorted { $0.value < $1.value }
        
//        for (token, result) in tokenWithResults {
//            tokenWithResults[token]  = result.sorted(by: { $0.1 < $1.1 }).reduce(into: [:]) { $0[$1.0] = $1.1 }
//        }
        
        
    }
    
    func bestLevensthein(for token: String, comparisonTokens: [String]) -> Int? {
        comparisonTokens.map { comparisonToken in
            let result = Int(Double(token.levenshtein(compareTo: comparisonToken))/Double(comparisonToken.count)*100)
            
            print("For token \(token) and compToken \(comparisonToken): \(result)")
            
            return result
        }.min()
    }
    
    func fetch() async {
        await vm.getGrades()
    }
    
    func tokenize(_ input: String) -> [String] {
        let updatedInput = input.trimmingCharacters(in: .whitespaces).lowercased().folding(options: [.diacriticInsensitive], locale: .current).keep(validChars: Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")).split(separator: " ").map({String($0)})

        return updatedInput
    }
    
}

extension String {
    func keep(validChars: Set<Character>) -> String {
        return String(self.filter {validChars.contains($0)})
    }
    
    ///Source: https://gist.github.com/bgreenlee/52d93a1d8fa1b8c1f38b
    func levenshtein(compareTo: String) -> Int {
        // create character arrays
        let a = Array(self)
        let b = Array(compareTo)

        // initialize matrix of size |a|+1 * |b|+1 to zero
        var dist = [[Int]]()
        for _ in 0...a.count {
            dist.append([Int](repeating: 0, count: b.count + 1))
        }

        // 'a' prefixes can be transformed into empty string by deleting every char
        for i in 1...a.count {
            dist[i][0] = i
        }

        // 'b' prefixes can be created from empty string by inserting every char
        for j in 1...b.count {
            dist[0][j] = j
        }

        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i][j] = dist[i-1][j-1]  // noop
                } else {
                    dist[i][j] = Swift.min(
                        dist[i-1][j] + 1,  // deletion
                        dist[i][j-1] + 1,  // insertion
                        dist[i-1][j-1] + 1  // substitution
                    )
                }
            }
        }

        return dist[a.count][b.count]
    }
}

struct WidgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        WidgetScreen(model: Model())
    }
}
