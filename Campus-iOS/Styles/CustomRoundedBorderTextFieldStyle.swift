//
//  CustomRoundedBorderTextFieldStyle.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import Foundation
import SwiftUI

struct CustomRoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}
