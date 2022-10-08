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
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .if(colorScheme == .light) { view in
                view.shadow(color: .gray.opacity(0.4), radius: 6)
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
    
    static var padding: CGFloat = 4
    
    var dimensions: (CGFloat, CGFloat) {
        
        var width = UIScreen.main.bounds.size.width * 0.9 * 0.5
        
        if width > 200 {
            width = 200
        }
        
        switch self {
        case .square:
            return (width - WidgetSize.padding, width - WidgetSize.padding)
        case .rectangle:
            return (2 * width, width)
        case .bigSquare:
            return (2 * width, 2 * width)
        }
    }
}
