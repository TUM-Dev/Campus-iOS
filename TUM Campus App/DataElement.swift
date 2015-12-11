//
//  DataElement.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import UIKit

protocol DataElement {
    func getCellIdentifier() -> String
    var text: String { get }
}