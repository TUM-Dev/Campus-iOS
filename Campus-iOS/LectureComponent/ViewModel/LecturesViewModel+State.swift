//
//  LecturesViewModel+State.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 25.12.21.
//

import Foundation

extension LecturesViewModel {
    enum State {
        case na
        case loading
        case success(data: [Lecture])
        case failed(error: Error)
    }
}
