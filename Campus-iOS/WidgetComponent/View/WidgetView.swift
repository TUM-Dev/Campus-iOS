//
//  WidgetView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 24.06.22.
//

import SwiftUI

struct WidgetView<Content: View>: View {
    
    let content: Content
    
    private let HEIGHT: CGFloat = 150
    
    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, minHeight: HEIGHT, maxHeight: HEIGHT)
            .background(.background)
            .cornerRadius(16)
            .shadow(radius: 10)
    }
}

struct WidgetView_Previews: PreviewProvider {
    
    static var widgetContent: some View {
        Text("Example Widget")
    }
    
    static var previews: some View {
        WidgetView(content: widgetContent)
        WidgetView(content: widgetContent)
            .preferredColorScheme(.dark)
    }
}
