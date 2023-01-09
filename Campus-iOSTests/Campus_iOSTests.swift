//
//  Campus_iOSTests.swift
//  Campus-iOSTests
//
//  Created by Milen Vitanov on 01.12.21.
//

import XCTest
@testable import Campus_iOS

let stringA = randomString(length: 5)
let stringB = randomString(length: 5)

class Campus_iOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceLev1() throws {
        // This is an example of a performance test case.
    
        var result = 0
        
        self.measure {
            result = stringA.levenshtein(to: stringB)
        }
    
        print(">>>>>>RESULTS Lev1<<<<<<<")
        print(stringA)
        print(stringB)
        print(result)
    }
    
    func testPerformanceLev2() throws {
        var result = 0
        
        self.measure {
            result = stringA.levenshtein(to: stringB)
        }
    
        print(">>>>>>RESULTS Lev2<<<<<<<")
        print(stringA)
        print(stringB)
        print(result)
    }
    
    

}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

/**
 * Levenshtein edit distance calculator
 *
 * Inspired by https://gist.github.com/bgreenlee/52d93a1d8fa1b8c1f38b
 * Improved with http://stackoverflow.com/questions/26990394/slow-swift-arrays-and-strings-performance
 */

class Levenshtein {

    private class func min(numbers: Int...) -> Int {
        return numbers.reduce(numbers[0], {$0 < $1 ? $0 : $1})
    }

    class Array2D {
        var cols:Int, rows:Int
        var matrix: [Int]

        init(cols:Int, rows:Int) {
            self.cols = cols
            self.rows = rows
            matrix = Array(repeating: cols*rows, count: 0)
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

    class func distanceBetween(aStr: String, and bStr: String) -> Int {
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
