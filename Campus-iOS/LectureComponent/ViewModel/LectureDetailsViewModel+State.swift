//
//  LectureDetailsViewModel+State.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import Foundation

extension LectureDetailsViewModel {
    enum State {
        case na
        case loading
        case success(data: LectureDetails)
        case failed(error: Error)
    }
}
