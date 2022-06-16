//
//  Collapsible.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI

struct Collapsible<Content: View>: View {
    @State var title: () -> AnyView
    @State var content: () -> Content
    @State var applyPadding = true
    @State var collapsed = true
    
    var body: some View {
        VStack {
            Button(
                action: {
                    withAnimation(.easeInOut) {
                        self.collapsed.toggle()
                    }
                },
                label: {
                    HStack {
                        self.title()
                        Spacer()
                        Image(systemName: "chevron.right")
                            .rotationEffect(Angle.degrees(self.collapsed ? 0 : 90))
                    }
                    .padding()
                    .background(Color.white.opacity(0.01))
                }
            )
            .if(applyPadding, transformT: { view in
                view.padding()
            })
            .buttonStyle(PlainButtonStyle())
            
            if !collapsed {
                self.content()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: collapsed ? 0 : .none, alignment: .top)
                .clipped()
                .animation(.easeOut, value: self.collapsed)
                .transition(.slide)
            }
        }
    }
}
