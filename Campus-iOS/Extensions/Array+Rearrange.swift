//
//  Array+Rearrange.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 02.02.22.
//

import Foundation

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}
