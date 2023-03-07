//
//  SearchResultErrorView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct SearchResultErrorView: View {
    @State var title: String
    @State var error: String
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                Text(title)
                    .fontWeight(.bold)
                    .font(.title)
                Text("Error searching: \(error)")
            }.padding()
        }
    }
}

struct SearchResultErrorView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultErrorView(title: "Grades", error: "No internet connection.")
    }
}
