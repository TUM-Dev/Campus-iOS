//
//  GradesViewModel+State.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import Foundation

extension GradesViewModel {
    enum State {
        case na
        case loading
        case success(data: [Grade])
        case failed(error: Error)
    }
}
