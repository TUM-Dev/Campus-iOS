//
//  StringExtension.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation

extension String {
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
