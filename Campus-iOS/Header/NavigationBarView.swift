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
            Color.primaryBackground
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(Color.primaryText).font(.system(size: 20))
                    Spacer()
                    if title == nil {
                        Image("logo-responsive")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35)
                            .foregroundColor(Color.primaryText)
                    } else {
                        Text(title!).font(.system(size: 17)).fontWeight(.semibold).foregroundColor(Color.primaryText)
                    }
                    Spacer()
                    Button(action: {model.showProfile.toggle()}) {
                        Image(systemName: "person.crop.circle").foregroundColor(Color.primaryText)
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
