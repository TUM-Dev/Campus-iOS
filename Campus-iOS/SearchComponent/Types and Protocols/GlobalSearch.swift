//
//  GlobalSearch.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation
typealias Distances = [Int]

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
    static func tokenSearch<T: Searchable>(for query: String, in searchables: [T]) -> [(T, Distances)]? {
    
        let tokens = tokenize(query)
        
        var levenshteinValues = [T: Distances]()
        
        for token in tokens {
            for searchable in searchables {
                
                // Retrieve the best relative levensthein value for the current token, i.e. if the token would be "kempr" the best relative levenshtein values is 16.
                guard let newDistance = bestRelativeLevensthein(for: token, with: searchable) else {
                    break
                }
//                print(newDistance)
                
                // Add new distance to the dictionary where the seachrable is the key.
                levenshteinValues[searchable, default: []].append(newDistance)
            }
        }
        
        let results = levenshteinValues
            .sorted { $0.value.sorted(by: <) >> $1.value.sorted(by: <) } // Sort the `searchable` ids by the increasing order since the lowest distance is the best.
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
            
//            let result = Int(Double(token.levenshtein(to: dataToken))/Double(dataToken.count)*100)
            let lev = token.levenshtein(to: dataToken)
            
            //Normalized Levenshtein Distance (see: https://ieeexplore.ieee.org/document/4160958)
            let result = Double(2 * lev) / Double(1 * (token.count + dataToken.count) + lev)
            //print("For token \(token) and compToken \(dataToken): \(result)")
            
            return Int(result * 100)
        }.min()
    }
    
    static func relativeLevensthein<T: Searchable>(for token: String, with searchable: T) -> [Int]? {
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
            
            //print("For token \(token) and compToken \(dataToken): \(result)")
            
            return result
        }
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

infix operator >>

func >>(_ lhs: [Int], _ rhs: [Int]) -> Bool {
    let index = min(lhs.count, rhs.count)
    for i in 0..<index {
        if lhs[i] < rhs[i] { // lhs is better if a e.g. the first value of lhs is > than the first value of rhs
            return true
        } else if lhs[i] > rhs[i] { // rhs is better if a e.g. all values until the 5th value are the same. The 5th value of lhs is < than the 5th value of rhs
            return false
        }
    }
    
    // If lhs == [] != rhs false is returned
    // If rhs == [] != lhs true is returned
    // If rhs == [] == lhs true is returned
    // If all values are the same, then return true if lhs has equal or more values than rhs else return false
    return lhs.count >= rhs.count
}
