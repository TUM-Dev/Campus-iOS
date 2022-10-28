//
//  GradeSet.swift
//  Campus-iOS
//
//  Created by David Lin on 24.10.22.
//

import Foundation
import CoreData

struct RowSet<T: NSManagedObject & Decodable>: Decodable {
    public var row: [T]
}

struct GradeSet: Decodable {
    public var row: [Grade]
}
