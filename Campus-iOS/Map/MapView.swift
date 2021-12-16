//
//  MapView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI

struct MapView: View {
    var body: some View {
            ZStack {
                MapContent()
                Panel()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                UITabBar.appearance().isOpaque = true
            }
        }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
