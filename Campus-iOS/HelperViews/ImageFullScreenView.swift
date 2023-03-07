//
//  ImageFullScreenView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.06.22.
//

import SwiftUI

struct ImageFullScreenView: View {
    
    @State var image: Image
    @State var zoomScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State var viewState = CGSize.zero

    var body: some View {
        GeometryReader { imageWrapper in
            self.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(self.zoomScale)
                .animation(.spring(), value: self.viewState)

                .offset(x: self.viewState.width, y: self.viewState.height)
                .gesture(DragGesture().onChanged {  val in
                    self.viewState = val.translation
                })
                .gesture(MagnificationGesture()
                    .onChanged { val in
                        let delta = val / self.lastScale
                        self.lastScale = val
                        if delta > 0.94 { // if statement to minimize jitter
                            let newScale = self.zoomScale * delta
                            self.zoomScale = newScale
                        }
                    }
                    .onEnded { _ in
                        self.lastScale = 1.0})
        }
    }
}

struct ImageFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ImageFullScreenView(image: Image(systemName: "photo"))
    }
}
