//
//  Campus_iOSTests.swift
//  Campus-iOSTests
//
//  Created by Milen Vitanov on 01.12.21.
//

import XCTest
@testable import Campus_iOS

class Campus_iOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testtest() throws {
        let a = "hello"
        let b = "hell0"
        
        let x = LevenshteinGreenlee.levenshtein(stringA: a, stringB: b)
    }

    func testIfEqualResults() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let classic = apply(method: LevenshteinGreenlee.levenshtein)
        let wiki = apply(method: LevenshteinWiki.distanceBetween)
        let marino = apply(method: LevenshteinNickyMarino.opti_leven_distance)
        
        print(classic)
        print(wiki)
        print(marino)
        
        if classic.count == marino.count {
            for i in classic.indices {
                if classic[i] != marino[i] {
                    print("At \(i): \(classic[i])")
                    print("At \(i): \(marino[i])")
                    assert(false)
                }
            }
        }
        
        if wiki.count == classic.count {
            for i in classic.indices {
                if classic[i] != wiki[i] {
                    print("At \(i): \(classic[i])")
                    print("At \(i): \(wiki[i])")
                    assert(false)
                }
            }
        }
    }

    func testPerformanceLev1() throws {
        // This is an example of a performance test case.
    
        var results = [Int]()
        
        self.measure {
            results = apply(method: LevenshteinGreenlee.levenshtein)
        }
    
        print(">>>>>>RESULTS Lev1<<<<<<<")
        print(results)
    }
    
    func testPerformanceLev2() throws {
        var results = [Int]()

        self.measure {
            results = apply(method: LevenshteinWiki.distanceBetween)
        }

        print(">>>>>>RESULTS Lev2<<<<<<<")
        print(results)
    }
    
    func testPerformanceLev3() throws {
        var results = [Int]()
        
        self.measure {
            results = apply(method: LevenshteinNickyMarino.opti_leven_distance)
        }
    
        print(">>>>>>RESULTS Lev3<<<<<<<")
        print(results)
    }
    
    
}

let A = randomStrings(amount: 30)
let B = randomStrings(amount: 30)

func apply(method: (String, String) -> Int) -> [Int] {
    
    var results = [Int]()
    
    print("applying started")
    print(A.count)
    print(B.count)
    if A.count == B.count {
        A.forEach { stringA in
            B.forEach { stringB in
                print("StringA: \(stringA) and StringB: \(stringB)")
                results.append(method(stringA, stringB))
                
            }
        }
    }
    print("applying finished")
    
    return results
}

func randomStrings(amount: Int) -> [String] {
    var strings = [String]()
    for _ in (1..<amount) {
        let randomLength = Int.random(in: (10...100))
        strings.append(randomString(length: randomLength))
    }
    return strings
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
  return String((0..<length).map{ _ in letters.randomElement()! })
}

/**
 * Levenshtein edit distance calculator
 *
 * Inspired by https://gist.github.com/bgreenlee/52d93a1d8fa1b8c1f38b
 * Improved with http://stackoverflow.com/questions/26990394/slow-swift-arrays-and-strings-performance
 */

struct LevenshteinWiki {

    private static func min(numbers: Int...) -> Int {
        return numbers.reduce(numbers[0], {$0 < $1 ? $0 : $1})
    }

    class Array2D {
        var cols:Int, rows:Int
        var matrix: [Int]

        init(cols:Int, rows:Int) {
            self.cols = cols
            self.rows = rows
            matrix = Array(repeating: 0, count: cols*rows)
        }

        subscript(col:Int, row:Int) -> Int {
            get {
                return matrix[cols * row + col]
            }
            set {
                matrix[cols*row+col] = newValue
            }
        }

        func colCount() -> Int {
            return self.cols
        }

        func rowCount() -> Int {
            return self.rows
        }
    }

    static func distanceBetween(aStr: String, and bStr: String) -> Int {
        let a = Array(aStr.utf16)
        let b = Array(bStr.utf16)

        let dist = Array2D(cols: a.count + 1, rows: b.count + 1)

        for i in 1...a.count {
            dist[i, 0] = i
        }

        for j in 1...b.count {
            dist[0, j] = j
        }

        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i, j] = dist[i-1, j-1]  // noop
                } else {
                    dist[i, j] = Swift.min(
                        dist[i-1, j] + 1,  // deletion
                        dist[i, j-1] + 1,  // insertion
                        dist[i-1, j-1] + 1  // substitution
                    )
                }
            }
        }

        return dist[a.count, b.count]
    }
}

struct LevenshteinGreenlee {
    static func levenshtein(stringA: String, stringB: String) -> Int {
        /// Either `self `or the `comparisonToken` is empty.
        if stringA.isEmpty && stringB.isEmpty {
            return 0
        } else if stringA.isEmpty {
            return stringB.count
        } else if stringB.isEmpty {
            return stringA.count
        }
        
        /// Starting with the levenshtein distance algorithm
        // Create character arrays
        let a = Array(stringA)
        let b = Array(stringB)
        
        // Initialize matrix of size |a|+1 * |b|+1 to zero
        var dist = [[Int]]()
        for _ in 0...a.count {
            dist.append([Int](repeating: 0, count: b.count + 1))
        }
        
        // 'a' prefixes can be transformed into empty string by deleting every char
        for i in 1...a.count {
            dist[i][0] = i
            print(i)
        }
        
        // 'b' prefixes can be created from empty string by inserting every char
        for j in 1...b.count {
            dist[0][j] = j
        }
        
        for i in 1...a.count {
            for j in 1...b.count {
//                print("\(a[i-1]) = \(b[j-1])")
//                print(dist)
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
        for i in 0...a.count {
            print(dist[i])
        }
        return dist[a.count][b.count]
    }
}

struct LevenshteinPackage {
    private struct _LevenshteinMatrix {
        let m, n: Int
        
        private var _values: [Int]
        
        init(m: Int, n: Int) {
            self.m = m
            self.n = n
            
            self._values = [Int](repeating: 0, count: m * n)
        }
        
        subscript(i: Int, j: Int) -> Int {
            get {
                return _values[i + j * m]
            }
            set {
                _values[i + j * m] = newValue
            }
        }
        
        func compute(at i: Int, _ j: Int, using u: String, _ v: String) -> Int {
            let indexU = u.index(u.startIndex, offsetBy: i)
            let indexV = v.index(v.startIndex, offsetBy: j)
            
            let a = u[indexU] == v[indexV] ? self[i - 1, j - 1] : Int.max
            let b = self[i - 1, j - 1] + 1 // Replace
            let c = self[i, j - 1] + 1 // Insert
            let d = self[i - 1, j] + 1 // Delete
            
            return min(a, b, c, d)
        }
    }

    static func levenshteinDistance(_ u: String, _ v: String) -> Int {
        let m = u.count
        let n = v.count
        
        var D = _LevenshteinMatrix(m: m, n: n)
        
        D[0, 0] = 0
        
        for i in 1..<m { D[i, 0] = i }
        for j in 1..<n { D[0, j] = j }
        
        for i in 1..<m {
            for j in 1..<n {
                D[i, j] = D.compute(at: i, j, using: u, v)
            }
        }
        
        return D[m - 1, n - 1]
    }

}

struct LevenshteinNickyMarino {
    static func opti_leven_distance(a: String, b: String) -> Int {
        // Check for empty strings first
        if (a.count == 0) {
            return b.count
        }
        if (b.count == 0) {
            return a.count
        }

        // Create an empty distance matrix with dimensions len(a)+1 x len(b)+1
        var dists = Array(repeating: Array(repeating: 0, count: b.count+1), count: a.count+1)

        // a's default distances are calculated by removing each character
        for i in 1...(a.count) {
            dists[i][0] = i
        }
        // b's default distances are calulated by adding each character
        for j in 1...(b.count) {
            dists[0][j] = j
        }

        // Find the remaining distances using previous distances
        for i in 1...(a.count) {
            for j in 1...(b.count) {
                // Calculate the substitution cost
                let cost = (Array(a)[i-1] == Array(b)[j-1]) ? 0 : 1

                dists[i][j] = min(
                    // Removing a character from a
                    dists[i-1][j] + 1,
                    // Adding a character to b
                    dists[i][j-1] + 1,
                    // Substituting a character from a to b
                    dists[i-1][j-1] + cost
                )
            }
        }

        return dists.last!.last!
    }
}
