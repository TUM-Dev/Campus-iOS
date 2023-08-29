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

struct ScrollableCardsViewModifier: ViewModifier { //only used for news credit: Milen Vitanov
    func body(content: Content) -> some View {
        content
            .background(Color.blue.opacity(0.05))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
            .padding(10)
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
