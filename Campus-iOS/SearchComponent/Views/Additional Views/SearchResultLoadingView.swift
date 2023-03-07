//
//  SearchResultLoadingView.swift
//  Campus-iOS
//
//  Created by David Lin on 07.03.23.
//

import SwiftUI

struct SearchResultLoadingView: View {
    @State var title: String
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                Text(title)
                    .fontWeight(.bold)
                    .font(.title)
                LoadingView(text: "Searching...")
            }.padding()
        }
    }
}

struct SearchResultLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultLoadingView(title: "Grades")
    }
}
