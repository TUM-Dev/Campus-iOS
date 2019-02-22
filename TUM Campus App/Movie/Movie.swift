//
//  Movie.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData

@objc class Movie: NSManagedObject, Entity {    
    
    enum CodingKeys: String, CodingKey {
        case datum
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(entity: Movie.entity(), insertInto: context)
    }
}
