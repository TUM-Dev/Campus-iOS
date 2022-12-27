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

struct GradeSearchView: View {
    @Binding var results: [(grade: Grade, distance: Int)]
    
    var body: some View {
        ForEach(results, id: \.grade.id) { gradeResult in
            VStack {
                Text(gradeResult.grade.title)
                Text(gradeResult.grade.grade)
                Text(gradeResult.grade.examiner)
            }
        }
    }
}

struct CafeteriaSearchView: View {
    @Binding var results: [(cafeteria: Cafeteria, distance: Int)]
    
    var body: some View {
        ForEach(results, id: \.cafeteria.id) { cafeteriaResult in
            VStack {
                Text(cafeteriaResult.cafeteria.title ?? "no cafeteria title")
                Text(cafeteriaResult.cafeteria.location.address)
                Text(cafeteriaResult.cafeteria.name)
            }
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
            ScrollView {
                ForEach(vm.orderedTypes, id: \.rawValue) { type in
                    switch type {
                    case .Grade:
                        GradeSearchView(results: $vm.gradeResults)
                    case .Cafeteria:
                        CafeteriaSearchView(results: $vm.cafeteriaResults)
                    case .News:
                        EmptyView()
                    case .StudyRoom:
                        EmptyView()
                    case .Lecture:
                        EmptyView()
                    }
                }
            }
           
//            VStack {
//                GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model), query: $query)
//                    .cornerRadius(25)
//                    .padding()
//                    .shadow(color: .gray.opacity(0.8), radius: 10)
//                CafeteriasSearchResultView(vm: CafeteriasSearchResultViewModel(), query: $query)
//                    .cornerRadius(25)
//                    .padding()
//                    .shadow(color: .gray.opacity(0.8), radius: 10)
//            }
//            ScrollView {
//                ForEach(vm.searchResults, id: \.id) { result in
//                    switch result.type {
//                    case .Grade:
////                        if let grade = result.values.first?.0 as? Grade {
////                            Text(grade.title)
////                        }
//                        if let gradeResults = result.values as? [(Grade, Int)] {
//                            ForEach(0..<gradeResults.count, id: \.self) { index in
//                                VStack {
//                                    Text(gradeResults[index].0.title)
//                                    //                            Text(gradeResults[index].0.title)
//                                    Text(gradeResults[index].0.examiner)
//                                    Text(gradeResults[index].0.grade)
//                                }
//                            }
//                        }
//                    case .Lecture:
//                        EmptyView()
//                    case .Cafeteria:
//                        EmptyView()
////                        if let cafeteriaResults = result.values as? [(Cafeteria, Int)] {
////                            ForEach(0..<cafeteriaResults.count, id: \.self) { index in
////                                VStack {
////                                    Text(cafeteriaResults[index].0.title)
////                                    Text(cafeteriaResults[index].0.location.address)
////                                    Text(cafeteriaResults[index].0.queue)
////                                }
////                            }
////                        }
//                    case .News:
//                        EmptyView()
//                    case .StudyRoom:
//                        EmptyView()
//                    }
//                }
//            }
            Spacer()
        }.onChange(of: query) { newQuery in
            Task {
                await vm.search(for: newQuery)
            }
        }
    }
    
    enum ResultType {
        case grade
        case cafeteria
    }
    
    @ViewBuilder
    func resultsView(for query: Binding<String>) -> some View {
        let resultViews = getBestMatches()
        
//        EmptyView()
        ForEach(0..<resultViews.count, id: \.self) { index in
            resultViews[index]
                .cornerRadius(25)
                .padding()
                .shadow(color: .gray.opacity(0.8), radius: 10)
        }
    }
    
    func getBestMatches() -> [AnyView] {
        let gradeSearchResultView = GradesSearchResultView(vm: GradesSearchResultViewModel(model: vm.model), query: $query)
        let cafeteriaSearchResultView = CafeteriasSearchResultView(vm: CafeteriasSearchResultViewModel(), query: $query)
        
        var results = [(Int, ResultType)]()
        if let bestGradeMatch = gradeSearchResultView.vm.results.first?.distance {
            results.append((bestGradeMatch, .grade))
        } else if let bestCafeteriaMatch = cafeteriaSearchResultView.vm.results.first?.distance {
            results.append((bestCafeteriaMatch, .cafeteria))
        }
        
        let sortedMatches : [AnyView] = results.sorted(by: {$0.0 < $1.0}).map {$0.1}.map { result in
            switch result {
            case .grade:
                return AnyView(gradeSearchResultView)
            case .cafeteria:
                return AnyView(cafeteriaSearchResultView)
            }
        }
        
        return  sortedMatches
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

struct SearchViewResult {
    let view: any View
    let distance: Int?
    
    init(view: some View, distance: Int?) {
        self.view = view
        self.distance = distance
    }
}


class SearchResultViewModel: ObservableObject {
    @Published var searchResults = [SearchResult]()
    @Published var searchDataTypeResult = [String:Double]()
    @Published var gradeResults = [(grade: Grade, distance: Int)]()
    @Published var cafeteriaResults = [(cafeteria: Cafeteria, distance: Int)]()
    @Published var orderedTypes = [SearchResultType]()
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
    
    func search(for query: String) async {
        let cleanedQuery = prepare(query)
        
        guard let modelOutput = dataTypeClassifier?.predictedLabelHypotheses(for: cleanedQuery, maximumCount: 5) else {
            return
        }
        for (label, accuracy) in modelOutput {
            print("\(label) was at \(accuracy)")
        }
        searchDataTypeResult = modelOutput
        
//        let gradeSearchVM = GradesSearchResultViewModel(model: self.model)
//        await gradeSearchVM.gradesSearch(for: query)
//
//        let cafeteriaSearchVM = CafeteriasSearchResultViewModel()
//        await cafeteriaSearchVM.cafeteriasSearch(for: query)
//
//        var resultOrder: [(SearchResultType, Int?)] = [(.Grade, gradeSearchVM.results.first?.distance),
//                                                       (.Cafeteria, cafeteriaSearchVM.results.first?.distance)]
//        resultOrder.sort { resultLhs, resultRhs in
//            if let bestLhs = resultLhs.1 {
//                if let bestRhs = resultRhs.1 {
//                    return bestLhs < bestRhs
//                } else {
//                    return true
//                }
//            } else if resultRhs.1 != nil {
//                return false
//            } else {
//                return true
//            }
//        }
//
//        var sortedResults = [SearchResult]()
//        for result in resultOrder {
//            switch result.0 {
//            case .Grade:
//                sortedResults.append(SearchResult(type: .Cafeteria, values: cafeteriaSearchVM.results))
//            case .Cafeteria:
//                sortedResults.append(SearchResult(type: .Grade, values: gradeSearchVM.results))
//            case .Lecture: break
//
//            case .News: break
//
//            case .StudyRoom: break
//
//            }
//        }
//
//        searchResults = sortedResults
        
        //--------------------------------------------------------------------------------
        
        var confidence = [SearchResultType: Int]()
        
        if let optionalGradeResults = await GradeSearch.find(for: query, with: self.model) {
            self.gradeResults = optionalGradeResults
            if let first = gradeResults.first {
                confidence[.Grade] = first.1
            }
        }
        
        if let optionalCafeteriaResults = await CafeteriaSearch.find(for: query) {
            self.cafeteriaResults = optionalCafeteriaResults
            if let first = cafeteriaResults.first {
                confidence[.Cafeteria] = first.1
            }
        }
        
        orderedTypes = confidence.sorted(by: {$0.value < $1.value}).map{$0.key}

    }
    
}

enum GradeSearch {
    static func find(for query: String, with model: Model) async -> [(grade: Grade, distance: Int)]? {
        let gradeVM = await GradesViewModel(model: model, service: GradesService())
        await gradeVM.getGrades()
        
        return await GlobalSearch.tokenSearch(for: query, in: gradeVM.grades)
    }
}

enum CafeteriaSearch {
    static func find(for query: String) async -> [(cafeteria: Cafeteria, distance: Int)]? {
        let cafeterias = await fetch()
        
        return GlobalSearch.tokenSearch(for: query, in: cafeterias)
    }
    
    static func fetch() async -> [Cafeteria] {
        var cafeterias = [Cafeteria]()
        do {
            cafeterias = try await CafeteriasService().fetch(forcedRefresh: false)
            return cafeterias
        } catch {
            print("No cafeterias were fetched")
        }
        
        return cafeterias
    }
}

struct SearchResult {
    let id = UUID()
    let type: SearchResultType
    var values: [(any Searchable, Int)]
}

enum SearchResultType: String {
    case Grade
    case Lecture
    case News
    case Cafeteria
    case StudyRoom
}

struct CafeteriasSearchResultView: View {
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

@MainActor
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

infix operator =/

struct ComparisonToken: Hashable {
    var value: String
    var type: ComparisonTokenType = .tokenized
    
    enum ComparisonTokenType {
        case tokenized
        case raw
    }
    
    static func =/ (lhs: Self, rhs: Self) -> Bool {
        guard lhs.value.count == rhs.value.count else {
            return false
        }
        
        for i in 0..<lhs.value.count {
            if Array(lhs.value)[i] != Array(rhs.value)[i] {
                return false
            }
        }
        
        return true
    }
    
    func testing() -> Bool {
        let a = ComparisonToken(value: "hello")
        let b = ComparisonToken(value: "olleh")
        
        return a =/ b
    }
}


protocol Searchable: Hashable {
    var comparisonTokens: [ComparisonToken] { get }
    
    func tokenize() -> [String]
}

extension Searchable {
    
    /// Produce an array of tokens from the `comprarisonTokens` stored in `self`.
    ///
    /// ```
    /// struct Grades: Searchable {
    ///     let id = UUID()
    ///     let title: String
    ///     let examiner: String
    ///     let grade: String
    ///     let semester: String
    ///
    ///     var comparisonTokens: [ComparisonToken] = {
    ///         ComparisonToken(value: title),
    ///         ComparisonToken(value: examiner),
    ///         ComparisonToken(value: grade, type: .raw),
    ///         ComparisonToken(value: semester)
    ///     }
    /// }
    ///
    /// let grade = Grade(title: "Grundlagen: Betriebssysteme", examiner: "Ott", grade: "2,7", semester: "21W")
    ///
    /// let comparisonTokens = grade.tokenize() // ["grundlagen", "betriebssysteme", "ott", "2,7", semester: "21w"]
    /// ```
    /// This method collects the `comparisonTokens` to one array if strings. Each `comparisonToken` is added to the array either `.raw`, i.e. the umodified `comparisonToken.value` or it is added `.tokenized`, i.e. the only lowercase letters, a single whitespace, and numbers from 0 to 9 are left. E.g. `comparisonToken.value = "Hello World! "`will be tokenized to `["hello", "world"]` and added to the returned array.
    ///
    /// > Important Note: This is just the standard implementation for the tokenization. If the respective type need a custom method, this can be overridden.
    ///
    /// - Returns: An array of Strings representing tokens.
    func tokenize() -> [String] {
        
        return self.comparisonTokens.flatMap { comparisonToken in
            if comparisonToken.type == .tokenized {
                return comparisonToken.value.trimmingCharacters(in: .whitespaces).lowercased().folding(options: [.diacriticInsensitive], locale: .current).keep(validChars: Set("abcdefghijklmnopqrstuvwxyz 1234567890")).split(separator: " ").map({String($0)})
            }
            
            return [comparisonToken.value]
        }
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

enum GlobalSearch {
    /// Returns an optional array of tuples in ascending order by the best search matches of a given array of a type you specify and a search `query`.
    ///
    /// ```
    /// struct Grades: Searchable {
    ///     let id = UUID()
    ///     let title: String
    ///     let examiner: String
    ///     let grade: String
    ///     let semester: String
    ///
    ///     var comparisonTokens: [ComparisonToken] = {
    ///         ComparisonToken(value: title),
    ///         ComparisonToken(value: examiner),
    ///         ComparisonToken(value: grade, type: .raw),
    ///         ComparisonToken(value: semester)
    ///     }
    /// }
    ///
    /// let grades = [
    ///     Grade(title: "Grundlagen: Betriebssysteme", examiner: "Ott", grade: "2,7", semester: "21W"),
    ///     Grade(title: "Einführung in die Informatik", examiner: "Seidl", grade: "2,0", semester: "22W"),
    /// ]
    ///
    /// let query = "grade ott"
    ///
    /// let results = tokenSearch(for: query, in: grades) // [
    ///     (Grade(title: "Grundlagen: Betriebssysteme", examiner: "Ott", grade: "2,7", semester: "21W"), 0),
    ///     (Grade(title: "Einführung in die Informatik", examiner: "Seidl", grade: "2,0", semester: "22W"), 80)
    /// ]
    /// ```
    ///
    /// > Warning: It can return nil if either the `query` is an empty String and/or if the `value`are an empty string of each `comparisonToken` of each `searchable`.
    ///
    /// - Parameters:
    ///     - query: A String representing the query to be searched for.
    ///     - searchables: An array of a type conforming to the `Searchable` protocol, which will be searched through by the `query`.
    /// - Returns: An array of tuples containing a object of the specified type conforming to `Searchable` and an Integer, representing the best relative levenshtein distance. The array is of ascending order by which object of the `searchables` matches `query` the most.
    static func tokenSearch<T: Searchable>(for query: String, in searchables: [T]) -> [(T, Int)]? {
        
        let tokens = tokenize(query)
        
        var levenshteinValues = [T: Int]()
        
        for token in tokens {
            for searchable in searchables {
                
                // Retrieve the best relative levensthein value for the current token, i.e. if the token would be "kempr" the best relative levenshtein values is 16.
                guard let newDistance = bestRelativeLevensthein(for: token, with: searchable) else {
                    return nil
                }
                print(newDistance)
                
                // If the id of the current `searchable` already is in the dictonary, check if it currently saved best (i.e. lowest) distance for this grade is greater than the `newDistance`.
                if let currentDistance = levenshteinValues[searchable], currentDistance > newDistance {
                    levenshteinValues[searchable] = newDistance
                } else if levenshteinValues[searchable] == nil { // Add the `newDistance` if there was no distance for the current grade id.
                    levenshteinValues[searchable] = newDistance
                }
                
            }
        }
        
        
        let results = levenshteinValues
            .sorted { $0.value < $1.value } // Sort the `searchable` ids by the increasing order since the lowest distance is the best.
            .map { levenshteinTuple in
                // Map the key and values to a tuple to have the tuple labels inside the respective ViewModel.
                return (levenshteinTuple.0, levenshteinTuple.1)
            }
        
        return results
    }
    
    /// Returns the best relative levenshtein value for a given `String` and a `Searchable`. The lower the result, the more common is the `token` to one property of the `searchable`.
    ///
    /// ```
    /// struct Grades: Searchable {
    ///     let id = UUID()
    ///     let title: String
    ///     let examiner: String
    ///     let grade: String
    ///     let semester: String
    ///
    ///     var comparisonTokens: [ComparisonToken] = {
    ///         ComparisonToken(value: title),
    ///         ComparisonToken(value: examiner),
    ///         ComparisonToken(value: grade, type: .raw),
    ///         ComparisonToken(value: semester)
    ///     }
    /// }
    ///
    /// let grade = Grade(title: "Grundlagen: Betriebssysteme", examiner: "Ott", grade: "2,7", semester: "21W")
    ///
    /// let relLevensheit = bestRelativeLevensthein(for: "betribsystme", searchable: grade) // 20
    /// ```
    /// It returns the relative levenshtein distance for `token` and one `comparisonToken`of the `searchable` and is calculated by the levenshtein distance between the the two strings divided by the length of the `comparisonToken` and multiplied by `100`. This requires `searchable` to conform to the `Searchable` protocol.
    ///
    /// > Warning: Empty `comparisonToken` will not be concidered when evaluating the best (i.e. lowest) relative levensthein distance. If all `comparisonTokens` and/or `token` are empty strings `nil` returns.
    ///
    /// - Parameters:
    ///     - token: The string to be compared to the `comparisonTokens`.
    ///     - searchable: The instance of an type conforming to the `Searchable` protocol, which needs to have a property `comparisonToken`. They represent the tokens of the `Searchable` which are compared to the `token`.
    /// - Returns: An optional integer indicating the best (lowest) relative levenshtein distance from `token` to the `searchable`.
    static func bestRelativeLevensthein<T: Searchable>(for token: String, with searchable: T) -> Int? {
        guard !token.isEmpty else {
            return nil
        }
        
        // Combine all tokens of the current searchable to one array of strings with `tokenize()`.
        // E.g.: ["grundlagen", "datenbanken", "kemper", "1,0", "in0008", "schriftlich", "21w", "informatik"]
        // Afterwards the relative levenshtein distance is calculated between the `token` and each `comparisonToken` from the `searchable`.
        
        return searchable.tokenize().compactMap { dataToken in
            guard dataToken.count > 0 else {
                return nil
            }
            
            let result = Int(Double(token.levenshtein(to: dataToken))/Double(dataToken.count)*100)
            
            print("For token \(token) and compToken \(dataToken): \(result)")
            
            return result
        }.min()
    }

    /// Produce an array of tokens from a `query`.
    ///
    /// ```
    /// let tokens = tokenize("grade Grundlagen:  Betriebssysteme ") // ["grade", "grundlagen", "betriebssysteme"]
    /// ```
    ///
    /// - Parameters:
    ///     - query: The string to be converted to tokens..
    /// - Returns: An array representing tokens derived from the `query`.
    static func tokenize(_ query: String) -> [String] {
        let updatedQuery = query.trimmingCharacters(in: .whitespaces).lowercased().folding(options: [.diacriticInsensitive], locale: .current).keep(validChars: Set("abcdefghijklmnopqrstuvwxyz 1234567890")).split(separator: " ").map({String($0)})

        return updatedQuery
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
