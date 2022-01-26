//
//  CardModifier.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 26.01.22.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}
