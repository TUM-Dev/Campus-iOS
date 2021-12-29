//
//  LoadingView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct FailedView: View {
    let errorDescription: String
    
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Image(uiImage: #imageLiteral(resourceName: "Error-logo"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack (alignment: .center, spacing: 30) {
                Text("oh no!")
                    .font(.title)
                
                Text("Someting went wrong.")
                    .multilineTextAlignment(.center)
                    .opacity(0.7)
                
                Text("Error: \(errorDescription)")
                    .multilineTextAlignment(.center)
                    .opacity(0.7)
                
                Button(action: {
                    
                }) {
                    Text("Try Again".uppercased())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                        .background(Capsule().foregroundColor(Color("tumBlue")))
                }
            }
            .padding(.horizontal, 70)
            .padding(.bottom, UIScreen.main.bounds.height * 0.1)
        }
    }
}

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailedView(errorDescription: "Network not present")
    }
}
