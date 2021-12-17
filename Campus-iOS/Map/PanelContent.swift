//
//  PanelContent.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import MapKit
import CoreLocation

struct PanelContent: View {
    @Binding var zoomOnUser: Bool
    
    private let handleThickness = CGFloat(0)
    
    let abc = ["a", "b", "c", "d"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: handleThickness / 2.0)
                .frame(width: .infinity, height: handleThickness)
                .foregroundColor(Color.secondary)
                .padding(5)
            VStack {
                HStack {
                    Button (action: {
                        self.zoomOnUser = true
                    }) {
                        Image(systemName: "location")
                            .font(.title2)
                    }
                    Spacer().frame(width: 8.75 * UIScreen.main.bounds.width/10,
                                   height: 1.25 * UIScreen.main.bounds.width/10)
                }
                List {
                    ForEach(abc, id: \.self) { item in
                        Text(item)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    func createList() {
    }
}

struct PanelContent_Previews: PreviewProvider {
    static var previews: some View {
        PanelContent(zoomOnUser: .constant(true))
    }
}
