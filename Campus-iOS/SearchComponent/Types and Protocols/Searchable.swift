//
//  Searchable.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation

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
