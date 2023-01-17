//
//  ViewModifiers.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 17.01.23.
//

import Foundation
import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
                .font(.headline.bold())
                .textCase(.uppercase)
                .foregroundColor(Color.highlightText)
            Spacer()
        }
        .padding(.leading, 40)
        .padding(.bottom, 5)
    }
}

extension View {
    func titleStyle() -> some View {
            modifier(Title())
        }
}
