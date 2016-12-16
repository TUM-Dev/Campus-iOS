//
//  Swift.swift
//
//  Created by Mathias Quintero on 11/20/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

public extension String {
    
    /// Will say if the String is a palindrome
    var isPalindrome: Bool {
        return self.reversed == self
    }
    
    /// Will return the string reversed
    var reversed: String {
        return String(<>characters)
    }
    
    /// Returns the decoded representation of the string
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return data.string
    }
    
    /// Returns the base 64 encoded representation of the string
    var base64Encoded: String? {
        return data?.base64EncodedString()
    }
    
    /// Encodes the string by escaping unallowed characters
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? self
    }
    
    /// Turns any string into a url
    var url: URL? {
        return URL(string: urlEncoded)
    }
    
    /// Data resulting by encoding using utf8
    var data: Data? {
        return data(using: .utf8)
    }
    
    /**
     Will try to decipher the Date coded into a string
     
     - Parameter format: format in which the date is coded (Optional: default is "dd.MM.yyyy hh:mm:ss a")
     
     - Returns: Date object for the time
     */
    func date(using format: String = "dd.MM.yyyy hh:mm:ss a") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
}

public extension String {
    
    /**
     Will say if a String matches a RegEx
     
     - Parameter pattern: RegEx you want to match
     - Parameter options: Extra options (Optional: Default is [])
     
     - Returns: Whether or not the string matches
     */
    func matches(pattern: String, options: NSRegularExpression.Options = []) throws -> Bool {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        return regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: 0.distance(to: utf16.count))) != 0
    }
    
}

extension String: Defaultable {

    /// Default Value
    public static let defaultValue = ""
    
}
