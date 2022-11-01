//
//  BaseCoreDataModel.swift
//  Campus-iOS
//
//  Created by David Lin on 01.11.22.
//

import Foundation
import CoreData

protocol CoreDataModel {
    static var viewContext: NSManagedObjectContext {get}
    func save() throws

    // Delete not needed. Commented out jic in the future its required.
//    func delete() throws
}

extension CoreDataModel where Self: NSManagedObject {
    static var viewContext: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    func save() throws {
        try Self.viewContext.save()
    }
    
//    func delete() throws {
//        try Self.viewContext.delete(self)
//        try save()
//    }
}
