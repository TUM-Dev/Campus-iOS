//
//  ImageFullScreenView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.06.22.
//

import SwiftUI

struct ImageFullScreenView: View {
    
    @State var image: Image
    @State var scale: CGFloat = 1.0
    
    var body: some View {
        self.image
            .resizable()
            .scaleEffect(self.scale)
            .aspectRatio(contentMode: .fit)
            .gesture(MagnificationGesture().onChanged { val in
                self.scale = val.magnitude
            }
        )
    }
}

struct ImageFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ImageFullScreenView(image: Image(systemName: "photo"))
    }
}
