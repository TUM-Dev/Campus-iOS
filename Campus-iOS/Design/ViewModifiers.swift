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
                .foregroundColor(Color.highlightText)
            Spacer()
        }
        .padding(.leading)
        .padding(.bottom, 10)
    }
}

struct ListSection: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: Size.cardWidth)
            .background(Color.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.regular))
    }
}

extension View {
    func titleStyle() -> some View {
            modifier(Title())
        }
    func sectionStyle() -> some View {
            modifier(ListSection())
        }
}
