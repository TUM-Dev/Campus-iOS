//
//  WidgetErrorView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 07.07.22.
//

import SwiftUI

struct TextWidgetView: View {
    
    let text: String
    
    var body: some View {
        Rectangle()
            .foregroundColor(.widget)
            .overlay {
                VStack {
                    Text(text)
                }
            }
    }
}

struct TextWidgetView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        WidgetFrameView(size: .square, content: TextWidgetView(text: "Some text"))
        WidgetFrameView(size: .square, content: TextWidgetView(text: "Some text"))
            .preferredColorScheme(.dark)
    }
}
