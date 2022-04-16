//
//  FailedView.swift
//  Campus-iOS
//
//  Created by Philipp Zagar on 21.12.21.
//

import SwiftUI

struct FailedView: View {
    let errorDescription: String
    let retryClosure: (Bool) async -> Void
    
    init(errorDescription: String, retryClosure: @escaping (Bool) async -> Void = { _ in }) {
        self.errorDescription = errorDescription
        self.retryClosure = retryClosure
    }
    
    var body: some View {
        VStack {
            ZStack (alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                Image("Error-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack (alignment: .center, spacing: 12) {
                    Text("oh no!")
                        .font(.title)
                    
                    Text("Someting went wrong.")
                        .multilineTextAlignment(.center)
                        .opacity(0.7)
                    
                    Text("Error: \(errorDescription)")
                        .multilineTextAlignment(.center)
                        .opacity(0.7)
                    
                    Button(action: {
                        Task {
                            await self.retryClosure(false)
                        }
                    }) {
                        Text("Try Again".uppercased())
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .padding(.horizontal, 30)
                            .background(Capsule().foregroundColor(Color("tumBlue")))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, UIScreen.main.bounds.height * 0.1)
            }
        }
        .padding(.bottom, 60)
    }
}

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailedView(errorDescription: "Network not present")
    }
}
