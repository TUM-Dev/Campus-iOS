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
        GeometryReader { geo in
            ZStack {
                Image("Error-logo-transparent")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: -geo.size.height*0.1)
   
                VStack (alignment: .center, spacing: 12) {
                    Spacer(minLength: geo.size.height * 0.48)
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
                            .lineLimit(1).font(.body)
                                .frame(width: 200, height: 48, alignment: .center)
                    }
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Color(.tumBlue))
                    .cornerRadius(10)
                    .padding()
                    
                    Spacer()
                }
            }.position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
        }
        
    }
}

struct FailedView_Previews: PreviewProvider {
    static var previews: some View {
        FailedView(errorDescription: "Network not present")
    }
}
