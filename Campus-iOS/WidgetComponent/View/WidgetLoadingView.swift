//
//  WidgetLoadingView.swift
//  Campus-iOS
//
//  Created by Robyn Kölle on 05.07.22.
//

import SwiftUI

struct WidgetLoadingView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    let text: String
    
    var body: some View {
        Rectangle()
            .foregroundColor(.widget)
            .overlay {
                VStack {
                    Text(text)
                    ProgressView()
                }
            }
    }
}

struct WidgetLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            ForEach(WidgetSize.allCases, id: \.self) { size in
                WidgetFrameView(size: size, content: WidgetLoadingView(text: "Loading content"))
            }
        }
        
        VStack {
            ForEach(WidgetSize.allCases, id: \.self) { size in
                WidgetFrameView(size: size, content: WidgetLoadingView(text: "Loading content"))
                    .preferredColorScheme(.dark)
            }
        }
    }
}
