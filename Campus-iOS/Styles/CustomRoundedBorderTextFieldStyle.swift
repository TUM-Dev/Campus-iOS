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
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 5).fill(Color(UIColor.systemGray6)))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(Color(UIColor.systemGray4))
            )
    }
}
