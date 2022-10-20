//
//  HashFunction.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 10.09.22.
//

import Foundation
import CryptoKit

struct HashFunction {
    
    // Source:
    // https://www.hackingwithswift.com/example-code/cryptokit/how-to-calculate-the-sha-hash-of-a-string-or-data-instance
    static func sha256(_ string: String) -> String {
        let inputData = Data(string.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
