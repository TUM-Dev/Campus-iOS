//
//  ImageFullScreenView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 08.06.22.
//

import SwiftUI

struct ImageFullScreenView: View {
    
    @State var image: Image
    @State var maxZoomScale: CGFloat = 5.0
    @State var minZoomScale: CGFloat = 1.0
    @State var previousZoomScale: CGFloat = 1.0
    @State var zoomScale: CGFloat = 1.0
    @State var viewState = CGSize.zero
    
    var body: some View {
        GeometryReader { imageWrapper in
            ScrollView([.vertical, .horizontal],
                       showsIndicators: false) {
                self.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: self.viewState.width, y: self.viewState.height)
                    .scaleEffect(self.zoomScale)
                    .onTapGesture(count: 2, perform: doubleTap)
                    .gesture(DragGesture().onChanged {  val in
                        self.viewState = val.translation
                    })
//                    .gesture(MagnificationGesture().onChanged { val in
//                        self.zoomScale = val.magnitude
//                    })
                    .gesture(MagnificationGesture()
                        .onChanged(onZoomGestureStarted)
                        .onChanged(onZoomGestureEnded))
            }
        }
    }
//    var pinchToZoomGesture: some Gesture {
//        MagnificationGesture()
//                    .onChanged(onZoomGestureStarted)
//                    .onEnded(onZoomGestureEnded)
//    }
    
    func doubleTap() {
        if self.zoomScale == 1 {
            withAnimation(.spring()) {
                self.zoomScale = 5
            }
        } else {
            // Reset Zoom
            withAnimation(.interactiveSpring()) {
                self.zoomScale = 1
            }
        }
    }
    
    
    func onZoomGestureStarted(value: MagnificationGesture.Value) {
        withAnimation(.easeIn(duration: 0.1)) {
            let delta = value / previousZoomScale
            previousZoomScale = value
            let zoomDelta = zoomScale * delta
            var minMaxScale = max(minZoomScale, zoomDelta)
            minMaxScale = min(maxZoomScale, minMaxScale)
            zoomScale = minMaxScale
        }
    }
    
    func onZoomGestureEnded(value: MagnificationGesture.Value) {
        previousZoomScale = 1
        if zoomScale <= 1 {
            // Reset Zoom
            withAnimation(.interactiveSpring()) {
                self.zoomScale = 1
            }
        } else if zoomScale > 5 {
            zoomScale = 5
        }
    }
}

struct ImageFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ImageFullScreenView(image: Image(systemName: "photo"))
    }
}
