//
//  FetchState.swift
//  Campus-iOS
//
//  Created by David Lin on 01.11.22.
//

import Foundation

enum FetchState {
    case na
    case loading
    case success
    case failed(error: Error)
}
