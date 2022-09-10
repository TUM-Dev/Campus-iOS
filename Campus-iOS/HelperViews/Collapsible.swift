//
//  Collapsible.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 27.01.22.
//

import SwiftUI

struct Collapsible<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme

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
                        self.title().foregroundColor(colorScheme == .dark ? .init(UIColor.white) : .init(UIColor.black))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor.lightGray))
                            .rotationEffect(Angle.degrees(self.collapsed ? 0 : 90))
                    }
                    .padding(5)
                    .background(Color.clear)
                }
            )
            .if(applyPadding, transformT: { view in
                view.padding()
            })
            
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
