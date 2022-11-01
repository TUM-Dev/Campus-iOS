//
//  RowSet.swift
//  Campus-iOS
//
//  Created by David Lin on 01.11.22.
//

import Foundation
import CoreData

struct RowSet<T: NSManagedObject & Decodable>: Decodable {
    public var row: [T]
}
