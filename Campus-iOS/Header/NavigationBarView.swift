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
        
        ZStack {
            Color.black
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.white).font(.system(size: 20))
                    Spacer()
                    if title == nil {
                        Image("logo-white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                    } else {
                        Text(title!).font(.system(size: 17)).fontWeight(.semibold)
                    }
                    Spacer()
                    Button(action: {model.showProfile.toggle()}) {
                        Image(systemName: "person.crop.circle").foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .sheet(isPresented: $model.showProfile) {
                        ProfileView(model: model)
                    }
                }.padding(10)
                Divider()
            }
        }
        .frame(height: 90)
        .frame(maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView(model: Model(), title: "Grades")
    }
}
