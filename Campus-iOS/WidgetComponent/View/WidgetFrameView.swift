//
//  WidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetFrameView<Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let size: WidgetSize
    let content: Content
    
    var body: some View {
        
        let (width, height) = size.dimensions
        
        content
            .frame(width: width, height: height)
            .cornerRadius(32)
            .if(colorScheme == .light) { view in
                view.shadow(radius: 5)
            }
    }
}

struct WidgetFrameView_Previews: PreviewProvider {
    
    static var widgetContent: some View {
        Rectangle()
            .foregroundColor(.widget)
            .overlay {
                Text("Some Widget")
            }
    }
    
    static var content: some View {
        ScrollView {
            VStack {
                HStack {
                    WidgetFrameView(size: .square, content: widgetContent)
                    WidgetFrameView(size: .square, content: widgetContent)
                }
                WidgetFrameView(size: .rectangle, content: widgetContent)
                WidgetFrameView(size: .bigSquare, content: widgetContent)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    static var previews: some View {
        content
        content.preferredColorScheme(.dark)
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
