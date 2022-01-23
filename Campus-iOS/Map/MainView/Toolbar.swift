//
//  Toolbar.swift
//  Campus-iOS
//
//  Created by ghjtd hbmu on 23.01.22.
//

import SwiftUI

struct Toolbar: View {
    @Binding var zoomOnUser: Bool
    @Binding var selectedCanteenName: String
    
    var body: some View {
        if selectedCanteenName != "" {
            HStack {
                Image(systemName: "figure.walk")
                Divider().frame(width: 15)
                Image(systemName: "doc.text")
            }
            .mask(Rectangle())
            .frame(width: 100, height: 40)
            .background()
            .cornerRadius(10.0)
            .position(x: 8 * UIScreen.main.bounds.width/10, y: 1.2 * UIScreen.main.bounds.height/10)
        }
    }
}

/*struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar()
    }
}*/
