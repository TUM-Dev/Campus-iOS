//
//  TokenPermissionsViewModel+State.swift
//  Campus-iOS
//
//  Created by David Lin on 17.10.22.
//

import Foundation

extension TokenPermissionsViewModel {
    enum State {
        case na
        case loading
        case success(data: Any?)
        case failed(error: Error)
    }
}
