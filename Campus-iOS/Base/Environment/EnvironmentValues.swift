//
//  EnvironmentValues.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

class EnvironmentValues: ObservableObject {
    @Published var user: User = User(token: "insertPersonalTokenhere")
}
