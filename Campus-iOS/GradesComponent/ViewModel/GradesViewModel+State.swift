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
        //Add managedObejctContext to the decoder, i.e. rewrite the fetch-function
        case success
        case failed(error: Error)
    }
}
