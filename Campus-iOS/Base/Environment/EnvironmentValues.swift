//
//  EnvironmentValues.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import Foundation

class EnvironmentValues: ObservableObject {
    @Published var user: User = User(token: "A7892CE95A8E38174AAFD3ED0E583829")
}
