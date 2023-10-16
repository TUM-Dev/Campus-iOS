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
    @State var viewState = CGSize.zero
    @State private var isRed = false
    @State private var timer: Timer?
    var map: NavigaTumRoomFinderMap?
    
    var body: some View {
        self.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay {
                if let roomFinderMap = map {
                    GeometryReader(content: { geometry in
                        Circle()
                            .frame(width: 15)
                            .position(
                                x: Double(roomFinderMap.x) / Double(roomFinderMap.width) * geometry.size.width,
                                y: Double(roomFinderMap.y) / Double(roomFinderMap.height) * geometry.size.height
                            )
                            .foregroundStyle(isRed ? Color.red : Color.green)
                    })
                } else {
                    EmptyView()
                }
            }
            .offset(x: self.viewState.width, y: self.viewState.height)
            .scaleEffect(self.scale)
            .gesture(DragGesture().onChanged {  val in
                self.viewState = val.translation
            })
            .gesture(MagnificationGesture().onChanged { val in
                self.scale = val.magnitude
            })
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 1 / 2, repeats: true) { timer in
                    withAnimation {
                        self.isRed.toggle()
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
    }
}

struct ImageFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ImageFullScreenView(image: Image(systemName: "photo"), map: NavigaTumRoomFinderMap(id: "rf182", name: "Garching b. München 35-39 Lageplan", imageUrl: "rf54.webp", height: 565, width: 800, x: 460, y: 287, scale: "1000"))
    }
}
