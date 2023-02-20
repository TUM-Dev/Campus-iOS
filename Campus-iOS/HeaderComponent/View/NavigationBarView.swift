//
//  NavigationBarView.swift
//  Campus-iOS
//
//  Created by Timothy Summers on 05.12.22.
//

import SwiftUI

struct NavigationBarView: View {
    @ObservedObject var model: Model
    var title: String?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.primaryBackground.edgesIgnoringSafeArea(.top)
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(Color.primaryText).font(.system(size: 20))
                        Spacer()
                        if self.title == nil {
                            Image("logo-blue")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 18)
                                .edgesIgnoringSafeArea(.all)
                                .foregroundColor(Color.primaryText)
                                .ignoresSafeArea()
                        } else {
                            Text(self.title!).font(.system(size: 17)).fontWeight(.semibold).foregroundColor(Color.primaryText)
                        }
                        Spacer()
                        Button(action: {model.showProfile.toggle()}) {
                            Image(systemName: "person.crop.circle").foregroundColor(Color.primaryText)
                                .font(.system(size: 20))
                        }
                        .sheet(isPresented: $model.showProfile) {
                            ProfileView(model: model)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                    Divider().overlay(Color.primaryBackground) //remove overlay to show Divider
                }
            }
            .frame(height: 50)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView(model: Model())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
        NavigationBarView(model: Model())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Plus"))
            .previewDisplayName("iPhone 14 Plus")
        NavigationBarView(model: Model())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
        NavigationBarView(model: Model())
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
            .previewDisplayName("iPad")
        
    }
}
