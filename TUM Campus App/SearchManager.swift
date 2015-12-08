//
//  SearchManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/8/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
protocol SearchManager: Manager {
    func setQuery(query: String)
    var query: String? { get set }
}