//
//  String+localized.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 30.10.22.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
