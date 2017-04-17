//
//  URL.swift
//  Pods
//
//  Created by Mathias Quintero on 12/26/16.
//
//

import Foundation

public extension URL {
    
    /**
     Will add a query to the url
     
     - Parameter key: Key of the query
     - Parameter value: Value encoded into the query
     
     - Returns: URL with the query
     */
    func appendingQuery(key: String, value: String) -> URL {
        let newQuery = "\(key)=\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).?
        let string = self.absoluteString + (??query ? "&" : "?") + newQuery
        return URL(string: string)!
    }
    
}
