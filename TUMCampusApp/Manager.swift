//
//  Manager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation

protocol Manager {
    init(mainManager: TumDataManager)
    func fetchData(handler: ([DataElement]) -> ())
}
