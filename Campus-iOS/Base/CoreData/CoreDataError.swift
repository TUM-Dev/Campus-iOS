//
//  CoreDataError.swift
//  Campus-iOS
//
//  Created by David Lin on 01.11.22.
//

import Foundation

enum CoreDataError: Error {
    case savingError(String)
    case loadingError(String)
    case deletingError(String)
}
