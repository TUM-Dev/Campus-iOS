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
            VStack {
                GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model), query: $query)
                    .cornerRadius(25)
                    .padding()
                    .shadow(color: .gray.opacity(0.8), radius: 10)
                CafeteriasSearchResultView(vm: CafeteriasSearchResultViewModel(), query: $query)
                    .cornerRadius(25)
                    .padding()
                    .shadow(color: .gray.opacity(0.8), radius: 10)
            }
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
    
    func prepare(_ query: String) -> String {
        let updatedQuery = query.trimmingCharacters(in: .whitespaces).lowercased().folding(options: [.diacriticInsensitive], locale: .current).keep(validChars: Set("abcdefghijklmnopqrstuvwxyz 1234567890?"))
        
        return updatedQuery
    }
    
    func search(for query: String) {
        let cleanedQuery = prepare(query)
        
        guard let modelOutput = dataTypeClassifier?.predictedLabelHypotheses(for: cleanedQuery, maximumCount: 5) else {
            return
        }
        for (label, accuracy) in modelOutput {
            print("\(label) was at \(accuracy)")
        }
        searchDataTypeResult = modelOutput
//        searchResults = modelOutput.map {
//            return SearchResult(type: <#T##SearchResultType#>, values: <#T##[Decodable]#>)
//        }
        
//        if query.contains("Grade") {
//            searchResults.append(SearchResult(type: .Grade, values: Grade.dummyData))
//            searchResults.append(SearchResult(type: .Lecture, values: Lecture.dummyData))
//        }
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

struct CafeteriasSearchResultView: View{
    @StateObject var vm: CafeteriasSearchResultViewModel
    @Binding var query: String

    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ForEach(vm.results, id: \.0) { result in
                    VStack {
                        Text(result.cafeteria.name).foregroundColor(.indigo)
                        Text(result.cafeteria.location.address).foregroundColor(.teal)
                        Text(String(result.cafeteria.queue?.percent ?? 0.0)).foregroundColor(.purple)
                    }
                }
            }
        }
        .onChange(of: query) { newQuery in
            print(query)
            Task {
                await vm.cafeteriasSearch(for: newQuery)
            }
        }
    }
}

class CafeteriasSearchResultViewModel: ObservableObject {
    
    @Published var results = [(cafeteria: Cafeteria, distance: Int)]()
    private let cafeteriaService: CafeteriasServiceProtocol = CafeteriasService()
    
    
    func cafeteriasSearch(for query: String) async {
        
        let cafeterias = await fetch()
        
        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: cafeterias) {
            
            self.results = optionalResults
        }
    }
    
    func fetch() async -> [Cafeteria] {
        var cafeterias = [Cafeteria]()
        do {
            cafeterias = try await cafeteriaService.fetch(forcedRefresh: false)
            return cafeterias
        } catch {
            print("No cafeterias were fetched")
        }
        
        return cafeterias
    }
}

struct GradesSearchResultView: View {
    
    @StateObject var vm: GradesSearchResultViewModel
    @Binding var query: String
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView {
                ForEach(vm.results, id: \.0) { result in
                    VStack {
                        Text(result.grade.title).foregroundColor(.indigo)
                        Text(result.grade.examiner).foregroundColor(.teal)
                        Text(result.grade.grade).foregroundColor(.purple)
                    }
                }
            }
        }
        .onChange(of: query) { newQuery in
            print(query)
            Task {
                await vm.gradesSearch(for: newQuery)
            }
        }
    }
}

struct ComparisonToken: Hashable {
    var value: String
    var type: ComparisonTokenType = .tokenized
    
    enum ComparisonTokenType {
        case tokenized
        case raw
    }
    
}

protocol Searchable: Hashable {
    var comparisonTokens: [ComparisonToken] { get }
    
    func tokenize(_ query: String) -> [String]
}

extension Searchable {
    func tokenize(_ input: String) -> [String] {
        let updatedInput = input.trimmingCharacters(in: .whitespaces).lowercased().folding(options: [.diacriticInsensitive], locale: .current).keep(validChars: Set("abcdefghijklmnopqrstuvwxyz 1234567890")).split(separator: " ").map({String($0)})
        
        return updatedInput
    }
}

class GradesSearchResultViewModel: ObservableObject {
    @ObservedObject var vm: GradesViewModel
    @Published var results = [(grade: Grade, distance: Int)]()
    
    init(model: Model) {
        self.vm = GradesViewModel(model: model, service: GradesService())
    }
    
    func gradesSearch(for query: String) async {
        await fetch()
        
        if let optionalResults = GlobalSearch.tokenSearch(for: query, in: vm.grades) {
            
            self.results = optionalResults
        }
        
//        let tokens = tokenize(query)
//
//        var levenshteinValues = [Grade: Int]()
//
//        for token in tokens {
//            for grade in vm.grades {
//                print(grade.title)
//
//                // Combine all tokens of the current grade to one array of tokens.
//                // E.g.: ["grundlagen", "datenbanken", "kemper", "1,0", "in0008", "schriftlich", "21w", "informatik"]
//                let gradeTokens = tokenize(grade.title)
//                                + tokenize(grade.examiner)
//                                + [grade.grade]
//                                + tokenize(grade.lvNumber)
//                                + tokenize(grade.modus)
//                                + tokenize(grade.semester)
//                                + tokenize(grade.studyDesignation)
//                print(gradeTokens)
//
//                // Retrieve the best relative levensthein value for the current token, i.e. if the token would be "kempr" the best relative levenshtein values is 16.
//                guard let newDistance = bestRelativeLevensthein(for: token, comparisonTokens: gradeTokens) else {
//                    return
//                }
//                print(newDistance)
//
//                // If the id of the current grade already is in the dictonary, check if it currently saved best (i.e. lowest) distance for this grade is greater than the `newDistance`.
//                if let currentDistance = levenshteinValues[grade], currentDistance > newDistance {
//                    levenshteinValues[grade] = newDistance
//                } else if levenshteinValues[grade] == nil { // Add the `newDistance` if there was no distance for the current grade id.
//                    levenshteinValues[grade] = newDistance
//                }
//
//            }
//        }
//
//
//        results = levenshteinValues
//            .sorted { $0.value < $1.value } // Sort the grade ids by the increasing order since the lowest distance is the best.
//            .map { levenshteinTuple in
//                // Map the key and values to a tuple to have the tuple labels.
//                return (grade: levenshteinTuple.0, distance: levenshteinTuple.1)
//            }
    }
    
    func fetch() async {
        await vm.getGrades()
    }
    
}

struct GlobalSearch {
    static func tokenSearch<T: Searchable>(for query: String, in searchables: [T]) -> [(T, Int)]? {
        
        let tokens = tokenize(query)
        
        var levenshteinValues = [T: Int]()
        
        for token in tokens {
            for searchable in searchables {
                
                // Combine all tokens of the current grade to one array of tokens.
                // E.g.: ["grundlagen", "datenbanken", "kemper", "1,0", "in0008", "schriftlich", "21w", "informatik"]
                
                
                // Retrieve the best relative levensthein value for the current token, i.e. if the token would be "kempr" the best relative levenshtein values is 16.
                guard let newDistance = bestRelativeLevensthein(for: token, with: searchable) else {
                    return nil
                }
                print(newDistance)
                
                // If the id of the current grade already is in the dictonary, check if it currently saved best (i.e. lowest) distance for this grade is greater than the `newDistance`.
                if let currentDistance = levenshteinValues[searchable], currentDistance > newDistance {
                    levenshteinValues[searchable] = newDistance
                } else if levenshteinValues[searchable] == nil { // Add the `newDistance` if there was no distance for the current grade id.
                    levenshteinValues[searchable] = newDistance
                }
                
            }
        }
        
        
        let results = levenshteinValues
            .sorted { $0.value < $1.value } // Sort the grade ids by the increasing order since the lowest distance is the best.
            .map { levenshteinTuple in
                // Map the key and values to a tuple to have the tuple labels.
                return (levenshteinTuple.0, levenshteinTuple.1)
            }
        
        return results
    }
    
    
    /// Returns the best relative levenshtein value for a given `token` and an array of `comparisonTokens`. The lower the more common is the `token` to one of the `comparisonTokens`.
    ///
    /// ```
    /// bestRelativeLevensthein(for: "hello", comparisonTokens: ["world", "hi", "helo"]) // 25
    /// ```
    /// The formula to calculate the relative levenshtein distance for `token` and one `comparisonToken` is the levenshtein distance between the two strings divided by the length of the `comparisonToken` and multiplied by `100`.
    ///
    /// > Warning: Emtpy `comparisonTokens` will not be concidered when evaluating the best (i.e. lowest) relative levensthein distance. If all `comparisonTokens` and/or `token` are empty strings `nil` returns.
    ///
    /// - Parameters:
    ///     - token: The string to be compared to the `comparisonTokens`.
    ///     - comparisonTokens: The array of strings which are compared to the `token`.
    /// - Returns: An optional integer indicating the best (lowest) relative levenshtein distance from `token` to the `comparisonTokens`.
    static func bestRelativeLevensthein<T: Searchable>(for token: String, with searchable: T) -> Int? {
        guard !token.isEmpty else {
            return nil
        }
        
            
        let dataTokens: [String] = searchable.comparisonTokens.flatMap { $0.type == .tokenized ? tokenize($0.value) : [$0.value]}
        
        return dataTokens.compactMap { dataToken in
            guard dataToken.count > 0 else {
                return nil
            }
            
            let result = Int(Double(token.levenshtein(to: dataToken))/Double(dataToken.count)*100)
            
            print("For token \(token) and compToken \(dataToken): \(result)")
            
            return result
        }.min()
    }
    
    static func tokenize(_ input: String) -> [String] {
        let updatedInput = input.trimmingCharacters(in: .whitespaces).lowercased().folding(options: [.diacriticInsensitive], locale: .current).keep(validChars: Set("abcdefghijklmnopqrstuvwxyz 1234567890")).split(separator: " ").map({String($0)})

        return updatedInput
    }
}

extension String {
    func keep(validChars: Set<Character>) -> String {
        return String(self.filter {validChars.contains($0)})
    }
    
    /// Retrieve the levenshtein distance betweent `self` and the string `comparisonToken`
    ///
    /// ```
    /// "helo".levenshtein(to: "hello") // 1
    /// ```
    /// The levenshtein distance calculates the distance of to string, i.e. tokens.
    /// This evalutes if two words are similiar even if misspelling occurs in one of the words.
    /// This implementation is not considered as one of the most efficient, but one of the most clearest.
    /// See the [source](https://gist.github.com/bgreenlee/52d93a1d8fa1b8c1f38b).
    ///
    /// - Parameters:
    ///     - comparisonToken: The string which is compared to `self`
    /// - Returns: The levenshtein distance as integer
    func levenshtein(to comparisonToken: String) -> Int {
        /// Either `self `or the `comparisonToken` is empty.
        if self.isEmpty && comparisonToken.isEmpty {
            return 0
        } else if self.isEmpty {
            return comparisonToken.count
        } else if comparisonToken.isEmpty {
            return self.count
        }
        
        /// Starting with the levenshtein distance algorithm
        // Create character arrays
        let a = Array(self)
        let b = Array(comparisonToken)

        // Initialize matrix of size |a|+1 * |b|+1 to zero
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
                    dist[i][j] = dist[i-1][j-1]  // Noop
                } else {
                    dist[i][j] = Swift.min(
                        dist[i-1][j] + 1,  // Deletion
                        dist[i][j-1] + 1,  // Insertion
                        dist[i-1][j-1] + 1  // Substitution
                    )
                }
            }
        }

        return dist[a.count][b.count]
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(vm: SearchResultViewModel(model: Model()), query: .constant("hello world"))
    }
}

struct WidgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        WidgetScreen(model: Model())
    }
}
