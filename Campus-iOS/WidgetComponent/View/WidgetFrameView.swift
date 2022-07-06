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
            .foregroundColor(Color("tumBlue"))
            .overlay {
                Text("Some Widget")
                    .foregroundColor(.white)
            }
    }
    
    static var previews: some View {
        
        VStack {
            ForEach(WidgetSize.allCases, id: \.self) { size in
                WidgetFrameView(size: size, content: widgetContent)
                    .padding(4)
            }
        }
        
        VStack {
            ForEach(WidgetSize.allCases, id: \.self) { size in
                WidgetFrameView(size: size, content: widgetContent)
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
