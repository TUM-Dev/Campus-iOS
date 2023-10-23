//
//  TestView.swift
//  Campus-iOS
//
//  Created by Mohanned Kandil on 23.10.2023.
//


import SwiftUI

struct EmptyGradesView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(decorative: "Error-logo-transparent")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: -geo.size.height*0.1)
                
                VStack (alignment: .center, spacing: 12) {
                    Text("You seem to not have any grades yet!")
                        .font(.system(size: 22))
                }
            }.multilineTextAlignment(.center)
        }
    }
}

struct EmptyGradesView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyGradesView()
    }
}
