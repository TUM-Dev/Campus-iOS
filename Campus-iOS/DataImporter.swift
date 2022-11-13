//
//  DataImporter.swift
//  Campus-iOS
//
//  Created by David Lin on 13.11.22.
//

import Foundation
import CoreData

class DataImporter {
  let importContext: NSManagedObjectContext

  init(persistentContainer: NSPersistentContainer) {
    importContext = persistentContainer.newBackgroundContext()
    importContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
  }
}
