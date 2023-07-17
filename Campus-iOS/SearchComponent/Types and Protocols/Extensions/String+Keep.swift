//
//  String+Keep.swift
//  Campus-iOS
//
//  Created by David Lin on 27.12.22.
//

import Foundation

extension String {
    func keep(validChars: Set<Character>) -> String {
        return String(self.filter {validChars.contains($0)})
    }
}
