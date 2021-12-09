//
//  TokenActivationTutorialView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.12.21.
//

import SwiftUI

struct TokenActivationTutorialView: View {
    
    @State var activeImageIndex = 1
    let imageSwitchTimer = Timer.publish(every: 5, on: .main, in: .common)
                                .autoconnect()
    
    var body: some View {
            ZStack(alignment: .center) {
                GeometryReader { geo in
                    Image("token_step\(activeImageIndex)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(y: geo.size.width / 2)
                        .onReceive(imageSwitchTimer, perform: { _ in
                            self.activeImageIndex = self.activeImageIndex % 5 + 1
                        })
                }
            }
            .background(Color(.systemBackground))
            .edgesIgnoringSafeArea(.all)
        }
}

struct TokenActivationTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TokenActivationTutorialView()
    }
}
