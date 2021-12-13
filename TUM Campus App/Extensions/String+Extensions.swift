//
//  String+Extensions.swift
//  TUM Campus App
//
//  Created by Nikolai Madlener on 12.12.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
