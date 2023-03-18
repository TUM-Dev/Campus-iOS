//
//  LoadingView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct LoadingView: View {
    let text: String
    let position: LoadingViewPosition
    
    init(text: String, position: LoadingViewPosition = .middle) {
        self.text = text
        self.position = position
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack(spacing: 8) {
                    ProgressView()
                    Text(text)
                }
            }.position(x: geo.size.width/2, y: geo.size.height * position.rawValue)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: "Fetching Grades")
    }
}

enum LoadingViewPosition: Double {
    case middle = 0.5
    case middletop =  0.25
}
