//
//  CustomEnvironmentValues.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

class CustomEnvironmentValues: ObservableObject {
    @Published var user: User = User(token: "")
    //@Published var user: User = User(token: "asdf")
}
