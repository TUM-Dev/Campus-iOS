//
//  WidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetView<Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let size: WidgetSize
    let content: Content
    
    var body: some View {
        
        let (width, height) = size.dimensions
        
        content
            .padding()
            .frame(width: width, height: height)
            .background(colorScheme == .light ? Color.white : Color("darkGray"))
            .cornerRadius(32)
            .if(colorScheme == .light) { view in
                view.shadow(radius: 5)
            }
    }
}

struct WidgetView_Previews: PreviewProvider {
    
    static var widgetContent = Text("Some Content")
    
    static var previews: some View {
        
        VStack {
            ForEach(WidgetSize.allCases, id: \.self) { size in
                WidgetView(size: size, content: widgetContent)
                    .padding(4)
            }
        }
        
        VStack {
            ForEach(WidgetSize.allCases, id: \.self) { size in
                WidgetView(size: size, content: widgetContent)
                    .padding(4)
                    .preferredColorScheme(.dark)
            }
        }
        
    }
}

enum WidgetSize: CaseIterable {
    
    case square, rectangle, bigSquare
    
    var dimensions: (CGFloat, CGFloat) {
        switch self {
        case .square:
            return (160, 160)
        case .rectangle:
            return (320, 160)
        case .bigSquare:
            return (320, 320)
        }
    }
}
